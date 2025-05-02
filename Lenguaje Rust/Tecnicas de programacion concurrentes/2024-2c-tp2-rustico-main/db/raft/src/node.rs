
use std::net::SocketAddr;
use serde::{Serialize, de::DeserializeOwned};
use shared::api::rpc::RPCServer;
use tokio::net::TcpStream;
use tokio::sync::{Mutex, RwLock};
use std::sync::Arc;
use std::time::{Duration, Instant};
use rand::{Rng, thread_rng};
use std::collections::HashMap;

use crate::peer::Peer;
use crate::state::*;
use crate::rpc::*;

use dbshared::{StateMachine, Queryable};

type GenericError = Box<dyn std::error::Error + Send + Sync>;

#[derive(Copy, Clone, Eq, PartialEq, Debug)]
enum NodeType {
  Candidate,
  Follower,
  Leader
}

pub struct RaftNode<T, S, Query, Res> where
  T: StorageBackend,
  S: StateMachine,
  Query: Send + Serialize + DeserializeOwned,
  Res: Send + Serialize + DeserializeOwned
{
  backend: Mutex<T>,
  peers: Vec<Peer<S::Input, Query, Res>>,
  state: RwLock<NodeState<S::Input>>,
  node_type: RwLock<NodeType>,
  last_heartbeat: RwLock<Instant>,
  id: u64,
  leader_id: RwLock<Option<u64>>,
  volatile_state: RwLock<VolatileState>,
  state_machine: RwLock<S>
}

impl<T, State, Query, Res> RaftNode<T, State, Query, Res> where
  T: StorageBackend<State=State> + Send + Sync,
  State: StateMachine + Queryable<Query, Res>,
  Query: Send + Serialize + DeserializeOwned,
  Res: Send + Serialize + DeserializeOwned
{
  pub async fn new(peers: HashMap<u64, SocketAddr>, mut backend: T, id: u64) -> Result<Self, GenericError> {
    let mut peer_conn = Vec::new();
    for (id, peer_addr) in peers {
      peer_conn.push(Peer::new(peer_addr, id));
    }
    let state = RwLock::new(backend.load().await?);
    let state_machine = State::new();
    Ok(Self {
      backend: Mutex::new(backend),
      peers: peer_conn,
      state,
      node_type: RwLock::new(NodeType::Follower),
      last_heartbeat: RwLock::new(Instant::now()),
      id,
      leader_id: RwLock::new(None),
      volatile_state: RwLock::new(VolatileState::default()),
      state_machine: RwLock::new(state_machine)
    })
  }
  pub async fn handle(self: Arc<Self>, socket: TcpStream) -> Result<(), GenericError> {
    let mut rpc: RPCServer<RaftRPCRequest<State::Input, Query>, RaftRPCResponse<Res>> = RPCServer::new(socket).await?;
    while let Ok(req) = rpc.get_request().await {
      println!("{}", serde_json::to_string(&req)?);
      let res = match req {
        RaftRPCRequest::AppendEntries(req) => RaftRPCResponse::AppendEntries(self.handle_append_entries(req).await?),
        RaftRPCRequest::RequestVote(req) => RaftRPCResponse::RequestVote(self.handle_request_vote(req).await?),
        RaftRPCRequest::ClientRequest(req) => RaftRPCResponse::ClientResponse(self.handle_client_request(req).await?)
      };
      rpc.send_response(&res).await?;
    }
    Ok(())
  }
  async fn handle_append_entries(self: &Self, mut req: AppendEntriesRequest<State::Input>) -> Result<AppendEntriesResponse, GenericError> {
    let mut state = self.state.write().await;
    let failure = Ok(AppendEntriesResponse {
      term: state.current_term,
      sucess: false
    });

    if req.term < state.current_term {
      return failure;
    }
    if req.prev_log_index != -1 {
      if let Some(entry) = state.log.get(req.prev_log_index as usize) {
        if entry.term != req.prev_log_term {
          return failure;
        }
      } else {
        return failure;
      }
    }
    state.log.truncate((req.prev_log_index + 1) as usize);
    state.log.append(&mut req.entries);

    self.volatile_state.write().await.commit_index = req.leader_commit;
    *self.leader_id.write().await = Some(req.leader_id);
    *self.last_heartbeat.write().await = Instant::now();
    if *self.node_type.read().await == NodeType::Candidate {
      *self.node_type.write().await = NodeType::Follower;
    }
    self.backend.lock().await.save(&state).await?;
    return Ok(AppendEntriesResponse {
      term: state.current_term,
      sucess: true
    })
  }
  async fn handle_request_vote(self: &Self, req: RequestVoteRequest) -> Result<RequestVoteResponse, GenericError> {
    let mut state = self.state.write().await;
    if req.term < state.current_term {
      return Ok(RequestVoteResponse {
        term: state.current_term,
        vote_granted: false
      })
    }
    if state.voted_for.is_none() || state.voted_for == Some(req.candidate_id) {
      if req.last_log_index >= state.log.len() as u64 { // TODO: also check term
        state.voted_for = Some(req.candidate_id);
        return Ok(RequestVoteResponse {
          term: state.current_term,
          vote_granted: true
        });
      }
    }
    Ok(RequestVoteResponse {
      term: state.current_term,
      vote_granted: false
    })
  }
  async fn handle_client_request(self: &Self, req: ClientRequest<Query, State::Input>) -> Result<ClientResponse<Res>, GenericError> {
    let leader_id = *self.leader_id.read().await;
    Ok(match req {
      ClientRequest::Query(q) => {
        let res = self.state_machine.read().await.query(&q);
        ClientResponse {
          sucess: true,
          leader_id,
          response: Some(res)
        }
      },
      ClientRequest::Operation(req) => {
        if *self.node_type.read().await != NodeType::Leader {
          return Ok(ClientResponse {
            sucess: false,
            leader_id,
            response: None
          })
        }
        let mut state = self.state.write().await;
        let term = state.current_term;
        state.log.push(Entry {
          term,
          op: req
        });
        ClientResponse {
          sucess: true,
          leader_id,
          response: None
        }
      },
    })
  }
  pub async fn main_loop(self: Arc<Self>) -> () {
    let mut interval = tokio::time::interval(Duration::from_millis(500));
    loop {
      interval.tick().await;
      let node_type = *self.node_type.read().await;
      println!("{:#?}", node_type);
      self.update_state_machine().await;
      match node_type {
        NodeType::Leader => {
          for peer in self.peers.iter() {
            self.update_follower(peer).await;
          }
        },
        NodeType::Candidate => {
          self.request_vote().await;
          let requirement = (self.peers.len() + 1) / 2;
          let votes = self.volatile_state.read().await.votes.len();
          if votes >= requirement {
            self.become_leader().await;
          } else if self.last_heartbeat.read().await.elapsed() >= Duration::from_millis(1000) {
            *self.node_type.write().await = NodeType::Follower;
            self.state.write().await.voted_for = None;
            let time = thread_rng().gen_range(0..2000);
            tokio::time::sleep(Duration::from_millis(time)).await;
          }
        },
        NodeType::Follower => {
          if self.last_heartbeat.read().await.elapsed() >= Duration::from_millis(2000) {
            self.new_election().await;
          }
        }
      };
    }
  }
  async fn request_vote(self: &Self) -> () {
    let state = self.state.read().await;
    for peer in self.peers.iter() {
      if let Ok(res) = peer.request_vote(RequestVoteRequest {
        term: state.current_term,
        candidate_id: self.id,
        last_log_index: state.log.len() as u64,
        last_log_term: 0
      }).await {
        if res.vote_granted {
          let mut vs = self.volatile_state.write().await;
          vs.votes.insert(peer.id);
        }
      }
    }
  }
  async fn become_leader(self: &Self) -> () {
    println!("becoming leader");
    let mut vs = self.volatile_state.write().await;
    vs.votes.clear();
    *self.leader_id.write().await = Some(self.id);
    // init nextIndex and matchIndex
    let state = self.state.read().await;
    let next_index = (state.log.len() as i64) - 1;
    for peer in self.peers.iter() {
      vs.next_index.insert(peer.id, next_index);
      vs.match_index.insert(peer.id, 0);
    }
    *self.node_type.write().await = NodeType::Leader;
  }
  async fn new_election(self: &Self) -> () {
    *self.node_type.write().await = NodeType::Candidate;
    *self.last_heartbeat.write().await = Instant::now();
    let mut state = self.state.write().await;
    state.current_term += 1;
    state.voted_for = Some(self.id);
  }
  async fn update_follower(self: &Self, peer: &Peer<State::Input, Query, Res>) -> () {
    let state = self.state.read().await;
    let mut vs = self.volatile_state.write().await;
    let mut next_index: i64 = *vs.next_index.get(&peer.id).unwrap_or(&-1);
    let new_next = state.log.len() as i64;
    let prev_log_term = if state.log.len() > 0 {
      match state.log.get(state.log.len() - 1) {
        Some(entry) => entry.term,
        None => 0
      }
    } else { 0 };
    while next_index >= -1 {
      let range = (if next_index < 0 { 0 } else { (next_index + 1) as usize })..(new_next as usize);
      let res = peer.append_entries(AppendEntriesRequest {
        term: state.current_term,
        leader_id: self.id,
        prev_log_index: next_index,
        prev_log_term,
        entries: (&state.log[range]).into(),
        leader_commit: vs.commit_index
      }).await;
      let Ok(res) = res else {
        return
      };
      println!("{:#?}", serde_json::to_string(&res));
      if res.sucess {
        vs.next_index.insert(peer.id, new_next - 1);
        vs.match_index.insert(peer.id, new_next - 1);
        return;
      }
      if res.term > state.current_term {
        *self.node_type.write().await = NodeType::Follower;
        return;
      }
      next_index -= 1;
    }
  }
  async fn update_state_machine(self: &Self) -> () {
    let state = self.state.read().await;
    let next_index = state.log.len() as i64;
    let mut vs = self.volatile_state.write().await;
    let mut head = vs.last_applied + 1;
    while next_index > head {
      println!("trying {head} -> {next_index}");
      let mut replicated = 0;
      for (_, idx) in vs.match_index.iter() {
        println!("checking if peer {idx}>{head}");
        if *idx >= head {
          replicated += 1;
        }
      }
      let requirement = (self.peers.len() + 1) / 2;
      if requirement > replicated && vs.commit_index < head {
        return;
      }
      let entry = &state.log[head as usize];
      self.state_machine.write().await.transition_mut(&entry.op);
      vs.commit_index = head;
      vs.last_applied = head;
      head += 1;
    }
  }
}


use std::net::SocketAddr;
use tokio::sync::Mutex;
use serde::{Serialize, de::DeserializeOwned};
use shared::api::rpc::RPCClient;
use crate::rpc::*;

type GenericError = Box<dyn std::error::Error + Send + Sync>;



pub struct Peer<Op, Query, Res> where
  Op:  Send + Serialize,
  Query: Send + Serialize,
  Res: Send + Serialize + DeserializeOwned
{
  pub id: u64,
  peer_addr: SocketAddr,
  rpc: Mutex<Option<RPCClient<RaftRPCRequest<Op, Query>, RaftRPCResponse<Res>>>>
}

impl<Op, Query, Res> Peer<Op, Query, Res> where
  Op:  Send + Serialize,
  Query: Send + Serialize,
  Res: Send + Serialize + DeserializeOwned
{
  pub fn new(addr: SocketAddr, id: u64) -> Self {
    Self {
      id,
      peer_addr: addr,
      rpc: Mutex::new(None)
    }
  }
  pub async fn make_request(self: &Self, req: &RaftRPCRequest<Op, Query>) -> Result<RaftRPCResponse<Res>, GenericError> {
    loop {
      let mut rpc = self.rpc.lock().await;
      if let Some(ref mut rpc) = &mut *rpc {
        if let Ok(res) = rpc.make_request(req).await {
          return Ok(res);
        }
      }
      *rpc = Some(RPCClient::new(self.peer_addr).await?);
    }
  }
  pub async fn append_entries(self: &Self, req: AppendEntriesRequest<Op>) -> Result<AppendEntriesResponse, GenericError> {
    match self.make_request(&RaftRPCRequest::AppendEntries(req)).await? {
      RaftRPCResponse::AppendEntries(res) => Ok(res),
      _ => panic!("Unexpected response type")
    }
  }
  pub async fn request_vote(self: &Self, req: RequestVoteRequest) -> Result<RequestVoteResponse, GenericError> {
    match self.make_request(&RaftRPCRequest::RequestVote(req)).await? {
      RaftRPCResponse::RequestVote(res) => Ok(res),
      _ => panic!("Unexpected response type")
    }
  }
}

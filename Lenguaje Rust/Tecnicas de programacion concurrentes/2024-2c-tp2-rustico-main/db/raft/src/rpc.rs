
use serde::{Serialize, Deserialize};
use crate::state::Entry;

#[derive(Debug, Serialize, Deserialize)]
pub struct AppendEntriesRequest<Op> {
  pub term: u64,
  pub leader_id: u64,
  pub prev_log_index: i64,
  pub prev_log_term: u64,
  pub entries: Vec<Entry<Op>>,
  pub leader_commit: i64
}
#[derive(Debug, Serialize, Deserialize)]
pub struct AppendEntriesResponse {
  pub term: u64,
  pub sucess: bool
}
#[derive(Debug, Serialize, Deserialize)]
pub struct RequestVoteRequest {
  pub term: u64,
  pub candidate_id: u64,
  pub last_log_index: u64,
  pub last_log_term: u64
}
#[derive(Debug, Serialize, Deserialize)]
pub struct RequestVoteResponse {
  pub term: u64,
  pub vote_granted: bool
}

#[derive(Debug, Serialize, Deserialize)]
pub enum ClientRequest<Q, Op> {
  Query(Q),
  Operation(Op)
}
#[derive(Debug, Serialize, Deserialize)]
pub struct ClientResponse<Res> {
  pub sucess: bool,
  pub leader_id: Option<u64>,
  pub response: Option<Res>
}

#[derive(Debug, Serialize, Deserialize)]
pub enum RaftRPCRequest<Op, Q> {
  AppendEntries(AppendEntriesRequest<Op>),
  RequestVote(RequestVoteRequest),
  ClientRequest(ClientRequest<Q, Op>)
}
#[derive(Debug, Serialize, Deserialize)]
pub enum RaftRPCResponse<Res> {
  AppendEntries(AppendEntriesResponse),
  RequestVote(RequestVoteResponse),
  ClientResponse(ClientResponse<Res>)
}

use serde::{Serialize, Deserialize};
use dbshared::StateMachine;
use std::collections::{HashMap, HashSet};

type GenericError = Box<dyn std::error::Error + Send + Sync>;

#[derive(Serialize, Deserialize)]
pub struct NodeState<Op> {
  pub current_term: u64,
  pub voted_for: Option<u64>,
  pub log: Vec<Entry<Op>>
}

pub struct VolatileState {
  pub commit_index: i64,
  pub last_applied: i64,
  pub votes: HashSet<u64>,
  pub next_index: HashMap<u64, i64>,
  pub match_index: HashMap<u64, i64>,
}

impl Default for VolatileState {
  fn default() -> Self {
    VolatileState {
      commit_index: -1,
      last_applied: -1,
      votes: Default::default(),
      next_index: Default::default(),
      match_index: Default::default()
    }
  }
}

impl<T> Default for NodeState<T> {
  fn default() -> Self {
    Self {
      current_term: 0,
      voted_for: None,
      log: Vec::new()
    }
  }
}

pub trait StorageBackend {
  type State: StateMachine;
  async fn save(self: &mut Self, data: &NodeState<<Self::State as StateMachine>::Input>) -> Result<(), GenericError>;
  async fn load(self: &mut Self) -> Result<NodeState<<Self::State as StateMachine>::Input>, GenericError>;
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Entry<Op> {
  pub term: u64,
  pub op: Op
}

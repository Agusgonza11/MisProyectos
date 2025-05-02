use crate::{StateMachine, Queryable};
use std::collections::HashMap;
use serde::{Deserialize, Serialize, de::DeserializeOwned};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub enum Operation<K, V> {
  SetKey(K, V),
  DelKey(K)
}

#[derive(Serialize, Deserialize, Debug)]
pub struct State<K, V> where
  K: Eq + std::hash::Hash {
  state: HashMap<K, V>
}

impl<K, V> StateMachine for State<K, V> where
  K: Eq + std::hash::Hash + Serialize + DeserializeOwned + Send + Sync + Clone,
  V: Serialize + DeserializeOwned + Send + Sync + Clone
  {
  type Input = Operation<K, V>;
  fn new() -> Self {
    State { state: HashMap::new() }
  }
  fn transition_mut(self: &mut Self, input: &Operation<K, V>) {
    match input {
      Operation::SetKey(key, value) => {
        self.state.insert(key.clone(), value.clone());
      }
      Operation::DelKey(key) => {
        self.state.remove(&key);
      }
    }
  }
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Query<K> {
  GetKey(K),
}

impl<K, V> Queryable<Query<K>, Option<V>> for State<K, V> where 
  K: Eq + std::hash::Hash, V: Clone {
  fn query(self: &Self, query: &Query<K>) -> Option<V> {
    match query {
      Query::GetKey(key) => self.state.get(&key).map(|v| v.clone())
    }
  }
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Request<K, V> {
  Query(Query<K>),
  Operation(Operation<K, V>)
}

pub mod kv;
use serde::{Serialize, de::DeserializeOwned};

pub trait StateMachine {
    type Input: DeserializeOwned + Serialize + Send + Sync + Clone;
    fn new() -> Self;
    fn transition_mut(self: &mut Self, input: &Self::Input);
}

pub trait Queryable<Q, R> {
    fn query(self: &Self, query: &Q) -> R;
}

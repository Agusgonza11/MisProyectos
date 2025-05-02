use dbshared::kv::*;
use dbshared::StateMachine;
use raft::node::RaftNode;
use raft::state::NodeState;
use serde::{Deserialize, Serialize};
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::net::TcpListener;
use std::collections::HashMap;

type GenericError = Box<dyn std::error::Error + Send + Sync>;

#[derive(Debug, Serialize, Deserialize)]
pub struct Config {
    id: u64,
    listen_addr: SocketAddr,
    peers: HashMap<u64, SocketAddr>,
    state_file: String,
}

struct FileBackend {
    v: State<String, String>,
}

impl raft::state::StorageBackend for FileBackend {
    type State = State<String, String>;
    async fn save(self: &mut Self, data: &NodeState<<Self::State as StateMachine>::Input>) -> Result<(), GenericError> {
        Ok(())
    }
    async fn load(self: &mut Self) -> Result<NodeState<<Self::State as StateMachine>::Input>, GenericError> {
        Ok(Default::default())
    }
}

#[tokio::main]
async fn main() -> Result<(), GenericError> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 2 {
        eprintln!("Incorrect argument count. Correct usage: cargo run /path/to/config.json");
        std::process::exit(1);
    }
    let config_file = std::fs::read_to_string(&args[1]).expect("Config file not found");
    let config: Config = serde_json::from_str(&config_file)?;
    let listener = TcpListener::bind(&config.listen_addr).await?;
    println!("Listening on {}", &config.listen_addr);
    let backend = FileBackend { v: State::new() };
    let node: RaftNode<FileBackend, State<String, String>, Query<String>, Option<String>> =
        RaftNode::new(config.peers, backend, config.id).await?;
    let node = Arc::new(node);
    {
        let st = node.clone();
        tokio::task::spawn(async move {
            st.main_loop().await;
        });
    }
    loop {
        let (socket, _) = listener.accept().await?;
        let st = node.clone();
        tokio::task::spawn(async move {
            st.handle(socket).await.unwrap();
        });
    }
}

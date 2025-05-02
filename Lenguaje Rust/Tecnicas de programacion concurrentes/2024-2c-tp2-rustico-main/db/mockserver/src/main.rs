use std::net::SocketAddr;
use dbshared::kv::{State, Request};
use dbshared::{StateMachine, Queryable};
use shared::api::rpc::RPCServer;

use std::sync::Arc;
use tokio::sync::Mutex;

use tokio::io::{AsyncBufReadExt, AsyncWriteExt, BufReader, BufWriter};
use tokio::net::{TcpListener, TcpStream};

type EmptyResult = Result<(), Box<dyn std::error::Error + Send + Sync>>;

#[tokio::main]
async fn main() -> EmptyResult {
    let args: Vec<String> = std::env::args().collect();
    let pair = match args.len() {
        2 => {
            format!("127.0.0.1:{}", args[1])
        }
        3 => {
            format!("{}:{}", args[1], args[2])
        }
        _ => {
            eprintln!("Incorrect argument count. Correct usage: cargo run [bind_addr] bind_port");
            std::process::exit(1);
        }
    };

    let addr: SocketAddr = pair.parse()?;
    let listener = TcpListener::bind(addr).await?;
    println!("Listening on {}", addr);

    let state: State<String, String> = State::new();
    let state = Arc::new(Mutex::new(state));

    loop {
        let (socket, _) = listener.accept().await?;
        let st = state.clone();
        tokio::task::spawn(async move {
            handler(st, socket).await.unwrap();
        });
    }
}

async fn handler(state: Arc<Mutex<State<String, String>>>, mut socket: TcpStream) -> EmptyResult {
    let mut rpc: RPCServer<Request<String, String>, Option<String>> = RPCServer::new(socket).await?;
    while let Ok(req) = rpc.get_request().await {
        let mut state = state.lock().await;
        let res = match req {
            Request::Query(q) => state.query(&q),
            Request::Operation(op) => {
                state.transition_mut(op);
                None
            }
        };
        rpc.send_response(&res).await?;
    }
    Ok(())
}


use std::net::SocketAddr;
use serde::{Serialize, de::DeserializeOwned, Deserialize};
use shared::api::rpc::RPCClient;
use std::collections::HashMap;

use dbshared::kv::{Operation, Query, Request};

type GenericError = Box<dyn std::error::Error + Send + Sync>;

#[derive(Debug, Serialize, Deserialize)]
struct ClientResponse<Res> {
  pub sucess: bool,
  pub leader_id: Option<u64>,
  pub response: Option<Res>
}
#[derive(Debug, Serialize, Deserialize)]
pub enum RaftRPCRequest<K, V> {
  ClientRequest(Request<K, V>)
}
#[derive(Debug, Serialize, Deserialize)]
pub enum RaftRPCResponse<Res> {
  ClientResponse(ClientResponse<Res>)
}

pub struct PeerConn<'a, K, V> {
    id: u64,
    rpc: RPCClient<RaftRPCRequest<&'a K, &'a V>, RaftRPCResponse<Option<V>>>
}

pub struct DbConnection<'a, K, V> {
    peers: HashMap<u64, SocketAddr>,
    conn: Option<PeerConn<'a, K, V>>
}

impl<'a, K, V> DbConnection<'a, K, V> where
    K: Serialize + DeserializeOwned + Send + Sync, V: Serialize + DeserializeOwned + Send + Sync {
    pub async fn new(peers: HashMap<u64, SocketAddr>) -> Result<Self, GenericError> {
        Ok(Self {
            peers,
            conn: None
        })
    }
    async fn make_request(self: &mut Self, req: &RaftRPCRequest<&'a K, &'a V>) -> Result<Option<V>, GenericError> {
        let sconn = &mut self.conn;
        let mut tries = 0;
        loop {
            match sconn {
                None => for (id, addr) in self.peers.iter().cycle().skip(tries) {
                    let rpc = RPCClient::new(*addr).await;
                    let _: () = match rpc {
                        Ok(rpc) => {
                            *sconn = Some(PeerConn {
                                id: *id,
                                rpc
                            });
                            break;
                        },
                        Err(_) => {}
                    };
                },
                Some(conn) => match conn.rpc.make_request(req).await {
                    Ok(res) => match res {
                        RaftRPCResponse::ClientResponse(res) => {
                            if res.sucess {
                                return Ok(res.response.flatten())
                            }
                            let Some(leader) = res.leader_id else {
                                // peer out of sync
                                *sconn = None;
                                tries += 1;
                                continue;
                            };
                            if leader == conn.id {
                                panic!("operation failed");
                            }
                            let addr = self.peers.get(&leader).expect("leader missing");
                            if let Ok(rpc) = RPCClient::new(*addr).await {
                                *sconn = Some(PeerConn {
                                    id: leader,
                                    rpc
                                });
                            }
                        }
                    },
                    Err(_) => {
                        *sconn = None;
                        tries += 1;
                    }
                }
            };
        }
    }
    pub async fn get_key(self: &mut Self, key: &'a K) -> Result<Option<V>, GenericError> {
        let req = Request::Query(Query::GetKey(key));
        let req = RaftRPCRequest::ClientRequest(req);
        let res = self.make_request(&req).await?;
        Ok(res)
    }
    pub async fn set_key(self: &mut Self, key: &'a K, value: &'a V) -> Result<(), GenericError> {
        let req = Request::Operation(Operation::SetKey(key, value));
        let req = RaftRPCRequest::ClientRequest(req);
        self.make_request(&req).await?;
        Ok(())
    }
    pub async fn del_key(self: &mut Self, key: &'a K) -> Result<(), GenericError> {
        let req = Request::Operation(Operation::DelKey(key));
        let req = RaftRPCRequest::ClientRequest(req);
        self.make_request(&req).await?;
        Ok(())
    }
}

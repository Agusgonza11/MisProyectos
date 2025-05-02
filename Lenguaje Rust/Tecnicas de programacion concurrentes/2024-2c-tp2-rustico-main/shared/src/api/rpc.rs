use serde::{de::DeserializeOwned, Serialize};
use std::net::SocketAddr;
use tokio::io::{AsyncBufReadExt, AsyncWriteExt, BufReader, BufWriter};
use tokio::net::tcp::{OwnedReadHalf, OwnedWriteHalf};
use tokio::net::TcpStream;

type GenericError = Box<dyn std::error::Error + Send + Sync>;

pub struct RPCClient<Req, Res> {
    reader: BufReader<OwnedReadHalf>,
    writer: BufWriter<OwnedWriteHalf>,
    _req_marker: std::marker::PhantomData<Req>,
    _res_marker: std::marker::PhantomData<Res>,
}

impl<Req, Res> RPCClient<Req, Res>
where
    Req: Send + Serialize,
    Res: Send + DeserializeOwned,
{
    pub async fn new(addr: SocketAddr) -> Result<Self, GenericError> {
        let socket = TcpStream::connect(addr).await?;
        let (rd, wr) = socket.into_split();
        let reader = BufReader::new(rd);
        let writer = BufWriter::new(wr);
        Ok(Self {
            reader,
            writer,
            _req_marker: std::marker::PhantomData,
            _res_marker: std::marker::PhantomData,
        })
    }
    pub async fn make_request(self: &mut Self, req: &Req) -> Result<Res, GenericError> {
        self.writer
            .write_all(serde_json::to_string(req)?.as_bytes())
            .await?;
        self.writer.write_all(b"\n").await?;
        self.writer.flush().await?;
        let mut resp = String::new();
        self.reader.read_line(&mut resp).await?;
        let response: Res = serde_json::from_str(&resp)?;
        Ok(response)
    }
}

pub struct RPCServer<Req, Res> {
    reader: BufReader<OwnedReadHalf>,
    writer: BufWriter<OwnedWriteHalf>,
    _req_marker: std::marker::PhantomData<Req>,
    _res_marker: std::marker::PhantomData<Res>,
}

impl<Req, Res> RPCServer<Req, Res>
where
    Req: Send + DeserializeOwned,
    Res: Send + Serialize,
{
    pub async fn new(socket: TcpStream) -> Result<Self, GenericError> {
        let (rd, wr) = socket.into_split();
        let reader = BufReader::new(rd);
        let writer = BufWriter::new(wr);
        Ok(Self {
            reader,
            writer,
            _req_marker: std::marker::PhantomData,
            _res_marker: std::marker::PhantomData,
        })
    }
    pub async fn get_request(self: &mut Self) -> Result<Req, GenericError> {
        let mut resp = String::new();
        self.reader.read_line(&mut resp).await?;
        let req: Req = serde_json::from_str(&resp)?;
        Ok(req)
    }
    pub async fn send_response(self: &mut Self, res: &Res) -> Result<(), GenericError> {
        self.writer
            .write_all(serde_json::to_string(res)?.as_bytes())
            .await?;
        self.writer.write_all(b"\n").await?;
        self.writer.flush().await?;
        Ok(())
    }
}

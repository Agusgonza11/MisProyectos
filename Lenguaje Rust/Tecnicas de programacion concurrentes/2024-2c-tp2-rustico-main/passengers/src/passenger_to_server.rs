use tokio::net::TcpStream as TokioTcpStream;
use tokio::io::{AsyncWriteExt, AsyncReadExt};
use std::io;
use crate::MessageReceiver;
use crate::MessageSend;


pub struct PassengerToServer {
    pub stream: Option<TokioTcpStream>,
}

impl PassengerToServer {
    pub fn new() -> Self {
        PassengerToServer { stream: None }
    }

    pub async fn connect_to_server(&mut self, server_address: &str) -> Result<(), io::Error> {
        match TokioTcpStream::connect(server_address).await {
            Ok(s) => {
                self.stream = Some(s);
                Ok(())
            }
            Err(e) => Err(e),
        }
    }

    pub async fn send_message(&mut self, request: MessageSend) -> Result<(), io::Error> {
        if let Some(ref mut stream) = self.stream {
            let serialized_request = match serde_json::to_string(&request) {
                Ok(json) => json,
                Err(_) => return Err(io::Error::new(io::ErrorKind::InvalidData, "Serialization failed")),
            };

            stream.write_all(serialized_request.as_bytes()).await?;
            stream.write_all(b"\n").await?;

            Ok(())
        } else {
            Err(io::Error::new(io::ErrorKind::NotConnected, "No hay conexión establecida"))
        }
    }

    pub async fn receive_message(&mut self) -> Result<MessageReceiver, io::Error> {
        if let Some(ref mut stream) = self.stream {
            // Buffer para almacenar el mensaje recibido
            let mut buffer = vec![0; 1024]; // Tamaño inicial; puedes ajustar según sea necesario
            // Lee los datos de la conexión
            let n = stream.read(&mut buffer).await?;
            if n == 0 {
                return Err(io::Error::new(io::ErrorKind::UnexpectedEof, "Conexión cerrada"));
            }
            // Convierte los datos en un String y deserialízalo en S2C
            let response: MessageReceiver = serde_json::from_slice(&buffer[..n]).map_err(|_| {
                io::Error::new(io::ErrorKind::InvalidData, "Error al deserializar la respuesta")
            })?;
            buffer.clear();
            Ok(response)
        } else {
            Err(io::Error::new(io::ErrorKind::NotConnected, "No hay conexión establecida"))
        }
    }
}

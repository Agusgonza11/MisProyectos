use actix::prelude::*;
use serde::{Deserialize, Serialize};
use std::net::SocketAddr;
use tokio::io::AsyncWriteExt;
use tokio::io::{AsyncBufReadExt, BufReader};
use tokio::net::tcp::{OwnedReadHalf, OwnedWriteHalf};
use tokio::net::{TcpListener, TcpStream};
use tokio::sync::mpsc::{Receiver, Sender};
use tokio::time::{sleep, Duration};

mod driver_actor;
mod passenger_actor;
mod payments_actor;
mod server_actor;

use crate::server_actor::{
    AcceptPayment, AcceptRide, CompleteRide, CreateDriver, CreatePassenger, CreatePaymentsSystem,
    CreateRide, DriverCompleteRide, DriverResponse, GatewayResponse, RefusePayment, RefuseRide,
    Register, ServerActor,
};

#[derive(Debug, Serialize, Deserialize)]
pub struct Config {
    id: u64,
    listen_addr: SocketAddr,
    peers: Vec<SocketAddr>,
    state_file: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub enum ExternalMessage {
    RejectedPayment,
    SearchingDriver,
    NoDriversAvailable,
    OnWay,
    RideCompleted,
    PaymentRide(u64),
    RefusedPay(usize, u64),
    AcceptedPay(usize, u64),
    RideOffer(usize, usize, usize, u64),
    AutorizePayment((u64, u64), (u64, u64), u64, usize),
    DriveToDestination((u64, u64), (u64, u64), u64, usize, usize, usize),
}

async fn send_message(mut writer: OwnedWriteHalf, mut rx: Receiver<ExternalMessage>) {
    while let Some(message) = rx.recv().await {
        println!(
            "el mensaje q voy a enviar al pasajero/driver/payment es {:?}",
            message
        );
        match serde_json::to_string(&message) {
            Ok(serialized_message) => {
                if let Err(e) = writer
                    .write_all((serialized_message + "\n").as_bytes())
                    .await
                {
                    eprintln!("Error al escribir mensaje: {:?}", e);
                    break;
                }
                if let Err(e) = writer.flush().await {
                    eprintln!("Error al hacer flush del mensaje: {:?}", e);
                    break;
                }
                sleep(Duration::from_millis(50)).await;
            }
            Err(e) => eprintln!("Error al serializar mensaje: {:?}", e),
        }
    }
    println!("Canal cerrado, tarea de escritura terminada.");
}

async fn handle_client(stream: TcpStream, server: Addr<ServerActor>) {
    let (reader, writer): (OwnedReadHalf, OwnedWriteHalf) = stream.into_split();
    let mut reader = BufReader::new(reader);
    let mut buffer = String::new();
    let (sender, rx): (Sender<ExternalMessage>, Receiver<ExternalMessage>) =
        tokio::sync::mpsc::channel(100);

    tokio::spawn(send_message(writer, rx));

    while let Ok(bytes_read) = reader.read_line(&mut buffer).await {
        if bytes_read == 0 {
            break; // Conexión cerrada
        }

        let message = buffer.trim().to_string();

        buffer.clear();
        match serde_json::from_str::<serde_json::Value>(&message) {
            Ok(value) => {
                if let Some(create_ride) = value.get("CreateRide") {
                    match serde_json::from_value::<CreateRide>(create_ride.clone()) {
                        Ok(create_ride) => {
                            println!("Recibido CreateRide: {:?}", create_ride);
                            server.do_send(CreatePassenger {
                                create_ride,
                                sender: sender.clone(),
                            });
                        }
                        Err(e) => println!("Error al deserializar CreateRide: {:?}", e),
                    }
                } else if let Some(register) = value.get("Register") {
                    match serde_json::from_value::<Register>(register.clone()) {
                        Ok(register) => {
                            println!("Recibido Register: {:?}", register);
                            server.do_send(CreateDriver {
                                sender: sender.clone(),
                                register,
                            });
                        }
                        Err(e) => println!("Error al deserializar Register: {:?}", e),
                    }
                } else if let Some(response) = value.get("DriverResponse") {
                    match serde_json::from_value::<DriverResponse>(response.clone()) {
                        Ok(response) => {
                            println!("Recibido DriverResponse: {:?}", response);
                            if response.response {
                                server.do_send(AcceptRide {
                                    ride_id: response.ride_id,
                                    passenger: response.passenger_id,
                                    driver_id: response.driver_id,
                                });
                            } else {
                                server.do_send(RefuseRide {
                                    ride_id: response.ride_id,
                                    passenger: response.passenger_id,
                                });
                            }
                        }
                        Err(e) => println!("Error al deserializar Register: {:?}", e),
                    }
                } else if let Some(response) = value.get("DriverCompleteRide") {
                    match serde_json::from_value::<DriverCompleteRide>(response.clone()) {
                        Ok(response) => {
                            println!("Recibido DriverCompleteRide: {:?}", response);
                            server.do_send(CompleteRide {
                                passenger: response.passenger_id,
                                ride_id: response.ride_id,
                                driver_id: response.driver_id,
                                payment: response.payment,
                            });
                        }
                        Err(e) => println!("Error al deserializar Register: {:?}", e),
                    }
                } else if let Some(response) = value.get("GatewayResponse") {
                    match serde_json::from_value::<GatewayResponse>(response.clone()) {
                        Ok(response) => {
                            println!("Recibido Gateway: {:?}", response);

                            if response.response {
                                server.do_send(AcceptPayment {
                                    start: response.start,
                                    end: response.end,
                                    payment: response.payment,
                                    passenger: response.passenger_id,
                                });
                            } else {
                                server.do_send(RefusePayment {
                                    passenger: response.passenger_id,
                                });
                            }
                        }
                        Err(e) => println!("Error al deserializar Register: {:?}", e),
                    }
                } else if value.as_str() == Some("Set") {
                    println!("Recibida aplicacion Gateway");
                    server.do_send(CreatePaymentsSystem {
                        sender: sender.clone(),
                    });
                } else {
                    println!("Mensaje desconocido o mal formateado");
                }
            }
            Err(e) => {
                println!("Error al deserializar el mensaje JSON: {:?}", e);
            }
        }
    }
}

#[actix::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();

    let (passenger_listener_addr, driver_listener_addr, payment_getawet_addr, config_file) =
        match args.len() {
            5 => (
                format!("127.0.0.1:{}", args[1]),
                format!("127.0.0.1:{}", args[2]),
                format!("127.0.0.1:{}", args[3]),
                args[4].to_string(),
            ),
            _ => {
                eprintln!("Uso incorrecto: cargo run [client_port] [driver_port] [payments_port]");
                std::process::exit(1);
            }
        };

    let passenger_listener = TcpListener::bind(passenger_listener_addr.clone()).await?;
    let driver_listener = TcpListener::bind(driver_listener_addr.clone()).await?;
    let payment_listener = TcpListener::bind(payment_getawet_addr.clone()).await?;

    let server = ServerActor::new(&config_file).await.start();

    let server_for_drivers = server.clone();
    let server_for_passengers = server.clone();
    let server_for_payment = server.clone();

    tokio::spawn(async move {
        println!("Listening for payments on {}", payment_getawet_addr);
        while let Ok((stream, _)) = payment_listener.accept().await {
            let server = server_for_payment.clone();
            tokio::spawn(handle_client(stream, server));
        }
    });

    tokio::spawn(async move {
        println!("Listening for drivers on {}", driver_listener_addr);
        while let Ok((stream, _)) = driver_listener.accept().await {
            let server = server_for_drivers.clone();
            tokio::spawn(handle_client(stream, server));
        }
    });

    tokio::spawn(async move {
        println!("Listening for passengers on {}", passenger_listener_addr);
        while let Ok((stream, _)) = passenger_listener.accept().await {
            let server = server_for_passengers.clone();
            tokio::spawn(handle_client(stream, server));
        }
    });
    tokio::signal::ctrl_c().await?;

    Ok(())
}

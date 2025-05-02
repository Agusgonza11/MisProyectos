use std::{env, time::Duration};
mod passenger_to_server;
mod config;
use passenger_to_server::PassengerToServer;
use config::Config;
use serde::{Deserialize, Serialize};


#[derive(Debug, Serialize, Deserialize)]
pub enum MessageSend {
    CreateRide {
        start: (u64, u64),
        end: (u64, u64),
        payment: u64,
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub enum MessageReceiver{
    RejectedPayment,
    SearchingDriver,
    NoDriversAvailable,
    OnWay,
    RideCompleted,
}


#[actix::main]
async fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() != 2 {
        eprintln!("Uso: cargo run <puerto>");
        return;
    }

    let port = &args[1];
    let server_address = format!("localhost:{}", port);
    let mut pasajero = PassengerToServer::new();

    if let Err(e) = pasajero.connect_to_server(&server_address).await {
        println!("Error al conectar con el servidor de conductores: {}", e);
        return;
    }

    let config = match Config::load_default() {
        Ok(config) => config,
        Err(e) => {
            eprintln!("Error al cargar archivo de configuración: {}", e);
            return;
        }
    };


    let request = MessageSend::CreateRide {
        start: config.start,
        end: config.end,
        payment: config.payment,
    };
    
    if let Err(e) = pasajero.send_message(request).await {
        println!("Error al enviar mensaje: {}", e);
    }
    

    loop {
        //actix::clock::sleep(Duration::from_secs(2)).await;

        match pasajero.receive_message().await {
            Ok(solicitud) => match solicitud {
                MessageReceiver::RejectedPayment => {
                    println!("Pago rechazado. Por favor, intente de nuevo o use otro método de pago.");
                    break;
                }
                MessageReceiver::SearchingDriver => {
                    println!("Viaje aceptado, se esta buscando conductor. Por favor, espere...");
                }
                MessageReceiver::NoDriversAvailable => {
                    println!("No hay conductores disponibles en este momento. Intente más tarde.");
                    break;
                }
                MessageReceiver::OnWay => {
                    println!("Conductor en camino. Espere atentamente");
                }
                MessageReceiver::RideCompleted => {
                    println!("El viaje se ha completado. Gracias por usar nuestro servicio.");
                    break;
                }
            },
            Err(e) => {
                println!("Error al recibir mensaje: {}", e);
                break;
            }
        }
    }
    actix::clock::sleep(Duration::from_secs(5)).await; // Mantengo el proceso principal corriendo para que se ejecute la tarea

}

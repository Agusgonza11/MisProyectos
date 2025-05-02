use std::{env, time::Duration};
mod driver_to_server;
mod config;
use driver_to_server::DriverToServer;
use config::Config;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub enum MessageSend {
    Register {
        position: (u64, u64),
    },
    DriverResponse {
        response: bool,
        ride_id: usize,
        passenger_id: usize,
        driver_id: usize,
    },
    DriverCompleteRide {
        ride_id: usize,
        passenger_id: usize,
        driver_id: usize,
        payment: u64,
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub enum MessageReceiver{
    PaymentRide(u64),
    RideOffer(usize, usize, usize, u64),
    DriveToDestination((u64, u64), (u64, u64), u64, usize, usize, usize),
}

async fn travel(start: (u64, u64), end: (u64, u64)) {
    // Calcular la distancia Manhattan entre las posiciones de inicio y fin.
    let distance_x = (end.0 as i64 - start.0 as i64).abs();
    let distance_y = (end.1 as i64 - start.1 as i64).abs();
    let total_distance = distance_x + distance_y;

    println!(
        "Iniciando viaje desde {:?} hasta {:?}. Distancia total: {} unidades.",
        start, end, total_distance
    );

    // Iterar por cada unidad de distancia.
    for i in 0..total_distance {
        actix::clock::sleep(Duration::from_secs(2)).await; // 2 segundos por unidad.
        println!("Avanzando... Progreso: {} / {}", i + 1, total_distance);
    }

    println!("Viaje completado. Llegamos a la posición final: {:?}", end);
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
    let mut driver = DriverToServer::new();

    if let Err(e) = driver.connect_to_server(&server_address).await {
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

    let register_request = MessageSend::Register {
        position: config.position
    };

    
    if let Err(e) = driver.send_message(register_request).await {
        println!("Error al enviar mensaje: {}", e);
    }
    

    loop {
        actix::clock::sleep(Duration::from_secs(2)).await;

        match driver.receive_message().await {
            Ok(solicitud) => match solicitud {
                MessageReceiver::PaymentRide(payment) => {
                    println!("Se recibió PaymentRide. Se te depositaron ${}", payment);
                },
                MessageReceiver::RideOffer(ride_id, passenger_id, driver_id, payment) => {
                    let decision = rand::random::<f32>();
                    if decision < 0.8 {
                        println!("Se acepto la oferta de viaje de {:?} por ${:?}", passenger_id, payment);
                        if let Err(e) = driver.send_message(MessageSend::DriverResponse {response: true, ride_id, driver_id, passenger_id}).await {
                            println!("Error al enviar mensaje: {}", e);
                        }
                    } else {
                        println!("Se rechazo la oferta de viaje de {:?} por ${:?}", passenger_id, payment);
                        if let Err(e) = driver.send_message(MessageSend::DriverResponse {response: false, ride_id, driver_id, passenger_id}).await {
                            println!("Error al enviar mensaje: {}", e);
                        }
                    };
                }
                MessageReceiver::DriveToDestination(start, end, payment, passenger_id, ride_id, driver_id) => {
                    travel(start, end).await;
                    if let Err(e) = driver.send_message(MessageSend::DriverCompleteRide {ride_id, driver_id, passenger_id, payment}).await {
                        println!("Error al enviar mensaje: {}", e);
                    }
                }
            },
            Err(_) => {
                break;
            }
        }
    }
    //actix::clock::sleep(Duration::from_secs(5)).await;

}

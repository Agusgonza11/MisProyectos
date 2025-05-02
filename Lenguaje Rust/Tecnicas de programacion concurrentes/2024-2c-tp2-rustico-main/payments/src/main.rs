use std::{env, time::Duration};
mod payments_to_server;
use payments_to_server::PaymentToServer;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub enum MessageSend {
    Set,
    GatewayResponse {
        response: bool,
        start: (u64, u64),
        end: (u64, u64),
        payment: u64,
        passenger_id: usize,
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub enum MessageReceiver {
    AutorizePayment((u64, u64), (u64, u64), u64, usize),
}

#[actix::main]
async fn main() {
    // Obtén los argumentos del programa
    let args: Vec<String> = env::args().collect();

    // Valida el número de argumentos
    if args.len() != 2 {
        eprintln!("Uso: cargo run <puerto>");
        return;
    }

    let port = &args[1];
    let server_address = format!("localhost:{}", port);

    // Crea una instancia de PaymentToServer
    let mut pay = PaymentToServer::new();

    // Conéctate al servidor
    if let Err(e) = pay.connect_to_server(&server_address).await {
        eprintln!("Error al conectar con el servidor de pagos: {}", e);
        return;
    }
    
    if let Err(e) = pay.send_message(MessageSend::Set).await {
        println!("Error al enviar mensaje: {}", e);
    }

    // Bucle principal
    loop {
        // Espera 2 segundos entre iteraciones
        actix::clock::sleep(Duration::from_secs(2)).await;

        // Recibe mensajes del servidor
        match pay.receive_message().await {
            Ok(solicitud) => match solicitud {
                MessageReceiver::AutorizePayment(start, end, payment, passenger_id) => {
                    let decision = rand::random::<f32>();
                    let response = if decision < 0.2 {
                        println!("El pago del user {:?} fue rechazado, total = ${:?}", passenger_id, payment);
                        false
                    } else {
                        println!("El pago del user {:?} fue aceptado, total = ${:?}", passenger_id, payment);
                        true
                    };
                    if let Err(e) = pay.send_message(MessageSend::GatewayResponse {response, start, end, payment, passenger_id}).await {
                        println!("Error al enviar mensaje: {}", e);
                    }
                }
            },
            Err(e) => {
                eprintln!("Error al recibir mensaje: {}", e);
                break; // Sal del bucle si ocurre un error
            }
        }
    }
}

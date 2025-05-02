use crate::server_actor::CreateRide;
use crate::ExternalMessage;
use crate::ServerActor;
use actix::prelude::*;
use tokio::sync::mpsc::Sender;

#[derive(Message)]
#[rtype(result = "()")]
pub struct AutorizePayment {
    pub ride: CreateRide,
    pub passenger_id: usize,
}

pub struct PaymentsActor {
    pub _server: Addr<ServerActor>,
    pub sender: Sender<ExternalMessage>,
}

impl PaymentsActor {
    pub fn new(server: Addr<ServerActor>, sender: Sender<ExternalMessage>) -> Self {
        PaymentsActor {
            _server: server,
            sender,
        }
    }
}

impl Actor for PaymentsActor {
    type Context = Context<Self>;
}

impl Handler<AutorizePayment> for PaymentsActor {
    type Result = ();

    fn handle(&mut self, msg: AutorizePayment, _: &mut Self::Context) -> Self::Result {
        let sender_clone = self.sender.clone();
        tokio::spawn(async move {
            if let Err(e) = sender_clone
                .send(ExternalMessage::AutorizePayment(
                    msg.ride.start,
                    msg.ride.end,
                    msg.ride.payment,
                    msg.passenger_id,
                ))
                .await
            {
                eprintln!("Error enviando mensaje: {:?}", e);
            }
        });
    }
}

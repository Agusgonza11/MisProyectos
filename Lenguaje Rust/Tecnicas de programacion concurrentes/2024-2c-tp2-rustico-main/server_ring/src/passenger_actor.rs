use crate::ExternalMessage;
use crate::ServerActor;
use actix::prelude::*;
use tokio::sync::mpsc::Sender;

#[derive(Message)]
#[rtype(result = "()")]
pub struct InformState {
    pub state: ExternalMessage,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct CreateRide {
    pub start: (u64, u64),
    _end: (u64, u64),
    _payment: u64,
}

pub struct PassengerActor {
    pub _id: usize,
    pub position: (u64, u64),
    pub _server: Addr<ServerActor>,
    pub sender: Sender<ExternalMessage>,
}

impl PassengerActor {
    pub fn new(
        id: usize,
        position: (u64, u64),
        server: Addr<ServerActor>,
        sender: Sender<ExternalMessage>,
    ) -> Self {
        let sender_clone = sender.clone();
        tokio::spawn(async move {
            if let Err(e) = sender_clone.send(ExternalMessage::SearchingDriver).await {
                eprintln!("Error enviando mensaje: {:?}", e);
            }
        });

        PassengerActor {
            _id: id,
            position,
            _server: server,
            sender,
        }
    }
}

impl Actor for PassengerActor {
    type Context = Context<Self>;
}

impl Handler<CreateRide> for PassengerActor {
    type Result = ();

    fn handle(&mut self, msg: CreateRide, _: &mut Self::Context) {
        self.position = msg.start;
        println!("Passenger start in position {:?}", self.position);
    }
}

impl Handler<InformState> for PassengerActor {
    type Result = ();

    fn handle(&mut self, msg: InformState, _: &mut Self::Context) {
        let sender_clone = self.sender.clone();
        tokio::spawn(async move {
            if let Err(e) = sender_clone.send(msg.state).await {
                eprintln!("Error enviando mensaje: {:?}", e);
            }
        });
    }
}

use crate::server_actor::Ride;
use crate::server_actor::ServerActor;
use crate::ExternalMessage;
use actix::prelude::*;
use actix::Message;
use tokio::sync::mpsc::Sender;

#[derive(Message)]
#[rtype(result = "()")]
pub struct GetPay {
    pub payment: u64,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct Register {
    pub position: (u64, u64),
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct Drive {
    pub ride: Ride,
    pub passenger: usize,
    pub ride_id: usize,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct RideOffer {
    pub ride: Ride,
    pub passenger: usize,
    pub ride_id: usize,
}

pub struct DriverActor {
    pub id: usize,
    pub position: (u64, u64),
    pub _server: Addr<ServerActor>,
    pub sender: Sender<ExternalMessage>,
    pub available: bool,
}

impl DriverActor {
    pub fn new(
        id: usize,
        position: (u64, u64),
        server: Addr<ServerActor>,
        sender: Sender<ExternalMessage>,
    ) -> Self {
        DriverActor {
            id,
            position,
            _server: server,
            sender,
            available: true,
        }
    }
}

impl Actor for DriverActor {
    type Context = Context<Self>;
}

impl Handler<Register> for DriverActor {
    type Result = ();

    fn handle(&mut self, msg: Register, _: &mut Self::Context) {
        self.position = msg.position;
        println!(
            "Driver {} registered at position: {:?}",
            self.id, self.position
        );
    }
}

impl Handler<RideOffer> for DriverActor {
    type Result = ();

    fn handle(&mut self, msg: RideOffer, _ctx: &mut Self::Context) -> Self::Result {
        if self.available {
            let sender_clone = self.sender.clone();
            let id = self.id;
            tokio::spawn(async move {
                if let Err(e) = sender_clone
                    .send(ExternalMessage::RideOffer(
                        msg.ride_id,
                        msg.passenger,
                        id,
                        msg.ride.payment,
                    ))
                    .await
                {
                    eprintln!("Error enviando mensaje: {:?}", e);
                }
            });
        }
    }
}

impl Handler<Drive> for DriverActor {
    type Result = ();

    fn handle(&mut self, msg: Drive, _ctx: &mut Self::Context) -> Self::Result {
        let sender_clone = self.sender.clone();
        let id = self.id;
        self.available = false;
        tokio::spawn(async move {
            if let Err(e) = sender_clone
                .send(ExternalMessage::DriveToDestination(
                    msg.ride.start,
                    msg.ride.end,
                    msg.ride.payment,
                    msg.passenger,
                    msg.ride_id,
                    id,
                ))
                .await
            {
                eprintln!("Error enviando mensaje: {:?}", e);
            }
        });
    }
}

impl Handler<GetPay> for DriverActor {
    type Result = ();

    fn handle(&mut self, msg: GetPay, _ctx: &mut Self::Context) -> Self::Result {
        let sender_clone = self.sender.clone();
        self.available = true;
        tokio::spawn(async move {
            if let Err(e) = sender_clone
                .send(ExternalMessage::PaymentRide(msg.payment))
                .await
            {
                eprintln!("Error enviando mensaje: {:?}", e);
            }
        });
    }
}

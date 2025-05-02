use crate::driver_actor::{Drive, DriverActor, GetPay, RideOffer};
use crate::passenger_actor::{InformState, PassengerActor};
use crate::payments_actor::{AutorizePayment, PaymentsActor};
use crate::ExternalMessage;
use actix::prelude::*;
use libclient::DbConnection;
use serde::Deserialize;
use serde::Serialize;
use std::collections::HashMap;
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::sync::mpsc::Sender;

const MAX_DISTANCE: f64 = 5.0; // Definir la distancia máxima permitida

// ----------------------------- Modelos y Estructuras -----------------------------

#[derive(Debug, Serialize, Deserialize)]
pub enum RideState {
    Searching(Ride),
    Accepted(Ride),
    Completed(Ride),
    Canceled(()),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Ride {
    pub start: (u64, u64),
    pub end: (u64, u64),
    pub payment: u64,
}

#[derive(Deserialize, Debug)]
pub struct CreateRide {
    pub start: (u64, u64),
    pub end: (u64, u64),
    pub payment: u64,
}

#[derive(Deserialize, Debug)]
pub struct Register {
    pub position: (u64, u64),
}

#[derive(Deserialize, Debug)]
pub struct DriverResponse {
    pub response: bool,
    pub ride_id: usize,
    pub passenger_id: usize,
    pub driver_id: usize,
}

#[derive(Deserialize, Debug)]
pub struct DriverCompleteRide {
    pub ride_id: usize,
    pub passenger_id: usize,
    pub driver_id: usize,
    pub payment: u64,
}

#[derive(Deserialize, Debug)]
pub struct GatewayResponse {
    pub response: bool,
    pub start: (u64, u64),
    pub end: (u64, u64),
    pub payment: u64,
    pub passenger_id: usize,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct CreateDriver {
    pub sender: Sender<ExternalMessage>,
    pub register: Register,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct CreatePassenger {
    pub sender: Sender<ExternalMessage>,
    pub create_ride: CreateRide,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct CreatePaymentsSystem {
    pub sender: Sender<ExternalMessage>,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct CompleteRide {
    pub passenger: usize,
    pub ride_id: usize,
    pub driver_id: usize,
    pub payment: u64,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct GetDriver {
    pub passenger: usize,
    pub ride: Ride,
    pub ride_id: usize,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct AcceptRide {
    pub passenger: usize,
    pub ride_id: usize,
    pub driver_id: usize,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct RefuseRide {
    pub passenger: usize,
    pub ride_id: usize,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct RefusePayment {
    pub passenger: usize,
}

#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct AcceptPayment {
    pub passenger: usize,
    pub start: (u64, u64),
    pub end: (u64, u64),
    pub payment: u64,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct UpdateRideState {
    pub ride_id: usize,
    pub new_state: RideState,
}

// ----------------------------- Actor: ServerActor -----------------------------

// Función para verificar si el conductor está dentro de la distancia permitida
fn is_proxim(start: (u64, u64), position: (u64, u64)) -> bool {
    let dx = start.0 as f64 - position.0 as f64;
    let dy = start.1 as f64 - position.1 as f64;
    let distance = (dx.powi(2) + dy.powi(2)).sqrt(); // Distancia Euclidiana
    distance <= MAX_DISTANCE // Devuelve true si la distancia está dentro del rango
}
pub struct ServerActor {
    drivers: HashMap<usize, Addr<DriverActor>>,
    drivers_positions: HashMap<usize, (u64, u64)>,
    passengers: HashMap<usize, Addr<PassengerActor>>,
    passengers_info: HashMap<usize, PassengerInfo>,
    rides: HashMap<usize, (usize, usize, RideState)>,
    drivers_ask_in_ride: HashMap<usize, Vec<usize>>,
    last_driver: usize,
    last_passenger: usize,
    last_ride: usize,
    payment_gatewey_addr: Option<Addr<PaymentsActor>>,
    db_connection: Arc<tokio::sync::Mutex<DbConnection<'static, String, String>>>,
}

impl ServerActor {
    pub async fn new(config_file_path: &str) -> Self {
        let config_file = std::fs::read_to_string(config_file_path).expect("Config file not found");
        let config: HashMap<u64, SocketAddr> =
            serde_json::from_str(&config_file).expect("Invalid config");
        // TODO: sacar unwrap
        let db_connection: DbConnection<String, String> = DbConnection::new(config)
            .await
            .expect("db connection error");
        let db_arc = Arc::new(tokio::sync::Mutex::new(db_connection));
        ServerActor {
            drivers: HashMap::new(),
            drivers_positions: HashMap::new(),
            passengers: HashMap::new(),
            passengers_info: HashMap::new(),
            rides: HashMap::new(),
            drivers_ask_in_ride: HashMap::new(),
            last_driver: 0,
            last_passenger: 0,
            last_ride: 0,
            payment_gatewey_addr: None,
            db_connection: db_arc,
        }
    }
}
impl Actor for ServerActor {
    type Context = actix::Context<Self>;
}

// ----------------------------- Handlers para el servidor -----------------------------
impl ServerActor {
    fn fetch_drivers(
        &mut self,
        msg: CreateDriver,
        ctx: &mut <ServerActor as actix::Actor>::Context,
    ) {
        let db_connection = Arc::clone(&self.db_connection);
        let key_str = Box::new("drivers".to_string());
        let key: &'static String = Box::leak(key_str);
        // Obtengo a los conductores desde la db y los seteo
        let future = Box::pin(
            async move {
                let drivers = db_connection.lock().await.get_key(key).await.unwrap();
                drivers
            }
            .into_actor(self)
            .map(|res, act, ctx| {
                match res {
                    None => {}
                    Some(drivers) => {
                        act.drivers_positions = serde_json::from_str(&drivers.clone()).unwrap();
                    }
                }
                ctx.address().do_send(FetchedDrivers(msg));
            }),
        );
        let _handle = ctx.spawn(future);
    }
    fn fetch_passengers(
        &mut self,
        msg: CreatePassenger,
        ctx: &mut <ServerActor as actix::Actor>::Context,
    ) {
        let db_connection = Arc::clone(&self.db_connection);
        let key_str = Box::new("passengers".to_string());
        let key: &'static String = Box::leak(key_str);
        // Obtengo a los conductores desde la db y los seteo
        let future = Box::pin(
            async move {
                let passengers = db_connection.lock().await.get_key(key).await.unwrap();
                passengers
            }
            .into_actor(self)
            .map(|res, act, ctx| {
                match res {
                    None => {}
                    Some(passengers) => {
                        act.passengers_info = serde_json::from_str(&passengers.clone()).unwrap();
                    }
                }
                ctx.address().do_send(FetchedPassengers(msg));
            }),
        );
        let _handle = ctx.spawn(future);
    }
    fn fetch_rides_and_accept_ride(
        &mut self,
        msg: AcceptRide,
        ctx: &mut <ServerActor as actix::Actor>::Context,
    ) {
        let db_connection = Arc::clone(&self.db_connection);
        let key_str = Box::new("rides".to_string());
        let key: &'static String = Box::leak(key_str);
        // Obtengo a los conductores desde la db y los seteo
        let future = Box::pin(
            async move {
                let rides = db_connection.lock().await.get_key(key).await.unwrap();
                rides
            }
            .into_actor(self)
            .map(|res, act, ctx| {
                match res {
                    None => {}
                    Some(rides) => {
                        act.rides = serde_json::from_str(&rides.clone()).unwrap();
                    }
                }
                ctx.address().do_send(PostAcceptRide(msg));
            }),
        );
        let _handle = ctx.spawn(future);
    }
    fn fetch_rides_and_refuse_ride(
        &mut self,
        msg: RefuseRide,
        ctx: &mut <ServerActor as actix::Actor>::Context,
    ) {
        let db_connection = Arc::clone(&self.db_connection);
        let key_str = Box::new("rides".to_string());
        let key: &'static String = Box::leak(key_str);
        // Obtengo a los conductores desde la db y los seteo
        let future = Box::pin(
            async move {
                let rides = db_connection.lock().await.get_key(key).await.unwrap();
                rides
            }
            .into_actor(self)
            .map(|res, act, ctx| {
                match res {
                    None => {}
                    Some(rides) => {
                        act.rides = serde_json::from_str(&rides.clone()).unwrap();
                    }
                }
                ctx.address().do_send(PostRefuseRide(msg));
            }),
        );
        let _handle = ctx.spawn(future);
    }
    fn fetch_rides_and_accept_payment(
        &mut self,
        msg: AcceptPayment,
        ctx: &mut <ServerActor as actix::Actor>::Context,
    ) {
        let db_connection = Arc::clone(&self.db_connection);
        let key_str = Box::new("rides".to_string());
        let key: &'static String = Box::leak(key_str);
        // Obtengo a los conductores desde la db y los seteo
        let future = Box::pin(
            async move { db_connection.lock().await.get_key(key).await.unwrap() }
                .into_actor(self)
                .map(|res, act, ctx| {
                    match res {
                        None => {}
                        Some(rides) => {
                            act.rides = serde_json::from_str(&rides.clone()).unwrap();
                        }
                    }
                    ctx.address().do_send(PostAcceptPayment(msg));
                }),
        );
        let _handle = ctx.spawn(future);
    }
}
impl Handler<CreatePaymentsSystem> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: CreatePaymentsSystem, ctx: &mut Self::Context) {
        let server_addr = ctx.address();
        self.payment_gatewey_addr =
            Some(PaymentsActor::new(server_addr.clone(), msg.sender).start());
    }
}
struct FetchedDrivers(CreateDriver);

impl actix::Message for FetchedDrivers {
    type Result = ();
}

impl Handler<FetchedDrivers> for ServerActor {
    type Result = ResponseActFuture<Self, ()>;
    fn handle(&mut self, msg: FetchedDrivers, ctx: &mut Self::Context) -> Self::Result {
        let msg = msg.0;
        self.last_driver += 1;
        let db_connection = Arc::clone(&self.db_connection);
        let driver_id = self.last_driver;
        let server_addr = ctx.address();
        let driver_actor = DriverActor::new(
            driver_id,
            msg.register.position,
            server_addr.clone(),
            msg.sender,
        );
        let driver_actor = driver_actor.start();
        self.drivers.insert(driver_id, driver_actor.clone());
        self.drivers_positions
            .insert(driver_id, msg.register.position);

        for (ride_id, (passenger, _drivers_asks, state)) in &self.rides {
            if let RideState::Searching(ride) = state {
                driver_actor.do_send(RideOffer {
                    ride: ride.clone(),
                    passenger: *passenger,
                    ride_id: *ride_id,
                });
            }
        }
        // Actualizo los conductores en la db
        let drivers_positions = serde_json::to_string(&self.drivers_positions).unwrap();
        let key_str = Box::new("drivers".to_string());
        let key: &'static String = Box::leak(key_str);
        let value_str = Box::new(drivers_positions.to_string());
        let value: &'static String = Box::leak(value_str);
        Box::pin(
            async move {
                db_connection
                    .lock()
                    .await
                    .set_key(key, value)
                    .await
                    .unwrap()
            }
            .into_actor(self)
            .map(|_res, _act, _ctx| {}),
        )
    }
}
impl Handler<CreateDriver> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: CreateDriver, ctx: &mut Self::Context) -> Self::Result {
        self.fetch_drivers(msg, ctx);
    }
}

struct FetchedPassengers(CreatePassenger);

impl actix::Message for crate::server_actor::FetchedPassengers {
    type Result = ();
}
impl Handler<FetchedPassengers> for ServerActor {
    type Result = ResponseActFuture<Self, ()>;
    fn handle(&mut self, msg: FetchedPassengers, ctx: &mut Self::Context) -> Self::Result {
        let msg = msg.0;
        self.last_passenger += 1;
        let passenger_id = self.last_passenger;
        let server_addr = ctx.address();
        let position = msg.create_ride.start;
        let passenger_actor =
            PassengerActor::new(passenger_id, position, server_addr.clone(), msg.sender);
        let passenger_actor = passenger_actor.start();
        self.passengers.insert(passenger_id, passenger_actor);

        if let Some(gateway) = &self.payment_gatewey_addr {
            gateway.do_send(AutorizePayment {
                ride: msg.create_ride,
                passenger_id,
            });
        }

        let passenger_info = PassengerInfo {
            id: passenger_id,
            position,
        };
        self.passengers_info.insert(passenger_id, passenger_info);
        let key_str = Box::new("passengers".to_string());
        let value_str = Box::new(
            serde_json::to_string(&self.passengers_info)
                .unwrap()
                .to_string(),
        );
        let key: &'static String = Box::leak(key_str);
        let value: &'static String = Box::leak(value_str);
        let db_connection = Arc::clone(&self.db_connection);
        Box::pin(
            async move {
                db_connection
                    .lock()
                    .await
                    .set_key(key, value)
                    .await
                    .unwrap();
            }
            .into_actor(self)
            .map(|_res, _act, _ctx| ()),
        )
    }
}
#[derive(Serialize, Deserialize)]
struct PassengerInfo {
    id: usize,
    position: (u64, u64),
}
impl Handler<CreatePassenger> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: CreatePassenger, ctx: &mut Self::Context) -> Self::Result {
        self.fetch_passengers(msg, ctx);
    }
}

impl Handler<GetDriver> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: GetDriver, _: &mut Self::Context) {
        println!("los disponibles son {:?}", self.drivers_ask_in_ride);

        if let Some(driver_id) = self
            .drivers_ask_in_ride
            .get_mut(&msg.ride_id.clone())
            .and_then(|drivers| drivers.pop())
        {
            // Si hay un conductor disponible
            if let Some(driver_addr) = self.drivers.get(&driver_id) {
                // Enviamos la oferta de viaje al conductor
                driver_addr.do_send(RideOffer {
                    ride: msg.ride.clone(),
                    passenger: msg.passenger,
                    ride_id: msg.ride_id,
                });

                // Eliminar el conductor de la lista después de enviar la oferta
                self.drivers_ask_in_ride
                    .get_mut(&msg.ride_id)
                    .unwrap()
                    .retain(|&id| id != driver_id);
            }
        } else {
            if let Some(passenger_addr) = self.passengers.get(&msg.passenger) {
                passenger_addr.do_send(InformState {
                    state: ExternalMessage::NoDriversAvailable,
                });
            }
            if let Some((_, _, state)) = self.rides.get_mut(&msg.ride_id) {
                if let RideState::Searching(_ride) = state {
                    *state = RideState::Canceled(());
                }
            }
        }
    }
}

struct PostAcceptRide(AcceptRide);
impl Message for PostAcceptRide {
    type Result = ();
}
impl Handler<PostAcceptRide> for ServerActor {
    type Result = ResponseActFuture<Self, ()>;

    fn handle(&mut self, msg: PostAcceptRide, _ctx: &mut Self::Context) -> Self::Result {
        let msg = msg.0;
        if let Some(passenger_addr) = self.passengers.get(&msg.passenger) {
            passenger_addr.do_send(InformState {
                state: ExternalMessage::OnWay,
            });
        }
        if let Some((_, _, state)) = self.rides.get_mut(&msg.ride_id) {
            if let RideState::Searching(ride) = state {
                let ride_clone = ride.clone();
                *state = RideState::Accepted(ride_clone.clone());
                if let Some(driver_addr) = self.drivers.get(&msg.driver_id) {
                    driver_addr.do_send(Drive {
                        ride_id: msg.ride_id,
                        passenger: msg.passenger,
                        ride: ride_clone,
                    });
                }
            }
        }

        let key_str = Box::new("rides".to_string());
        let value_str = Box::new(serde_json::to_string(&self.rides).unwrap().to_string());
        let key: &'static String = Box::leak(key_str);
        let value: &'static String = Box::leak(value_str);
        let db_connection = Arc::clone(&self.db_connection);
        Box::pin(
            async move {
                db_connection
                    .lock()
                    .await
                    .set_key(key, value)
                    .await
                    .unwrap();
            }
            .into_actor(self)
            .map(|_res, _act, _ctx| ()),
        )
    }
}

impl Handler<AcceptRide> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: AcceptRide, ctx: &mut Self::Context) {
        self.fetch_rides_and_accept_ride(msg, ctx);
    }
}

struct PostRefuseRide(RefuseRide);
impl Message for PostRefuseRide {
    type Result = ();
}
impl Handler<PostRefuseRide> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: PostRefuseRide, ctx: &mut Self::Context) -> Self::Result {
        let msg = msg.0;
        if let Some((_, _, RideState::Searching(ride))) = self.rides.get(&msg.ride_id) {
            ctx.address().do_send(GetDriver {
                passenger: msg.passenger,
                ride: ride.clone(),
                ride_id: msg.ride_id,
            });
        }
    }
}
impl Handler<RefuseRide> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: RefuseRide, ctx: &mut Self::Context) {
        self.fetch_rides_and_refuse_ride(msg, ctx);
    }
}

impl Handler<CompleteRide> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: CompleteRide, ctx: &mut Self::Context) -> Self::Result {
        if let Some(passenger_addr) = self.passengers.get(&msg.passenger) {
            passenger_addr.do_send(InformState {
                state: ExternalMessage::RideCompleted,
            });
        }
        if let Some(driver_addr) = self.drivers.get(&msg.driver_id) {
            driver_addr.do_send(GetPay {
                payment: msg.payment,
            });
        }

        if let Some((_, _, RideState::Accepted(ride))) = self.rides.get(&msg.ride_id) {
            if let Some(position) = self.drivers_positions.get_mut(&msg.driver_id) {
                *position = ride.end;
            }
            ctx.address().do_send(UpdateRideState {
                ride_id: msg.ride_id,
                new_state: RideState::Completed(ride.clone()),
            });
        }

        let key_str = Box::new("drivers".to_string());
        let value_str = Box::new(serde_json::to_string(&self.rides).unwrap().to_string());
        let key: &'static String = Box::leak(key_str);
        let value: &'static String = Box::leak(value_str);
        let db_connection = Arc::clone(&self.db_connection);
        ctx.spawn(
            async move {
                db_connection
                    .lock()
                    .await
                    .set_key(key, value)
                    .await
                    .unwrap();
            }
            .into_actor(self),
        );
    }
}

impl Handler<UpdateRideState> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: UpdateRideState, _: &mut Self::Context) -> Self::Result {
        if let Some((_, _, ref mut state)) = self.rides.get_mut(&msg.ride_id) {
            *state = msg.new_state;
        }
    }
}

struct PostAcceptPayment(AcceptPayment);
impl Message for PostAcceptPayment {
    type Result = ();
}

impl Handler<AcceptPayment> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: AcceptPayment, ctx: &mut Self::Context) {
        self.fetch_rides_and_accept_payment(msg, ctx);
    }
}
impl Handler<PostAcceptPayment> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: PostAcceptPayment, ctx: &mut Self::Context) {
        let msg = msg.0;
        self.last_ride += 1;
        let ride_id = self.last_ride;
        let ride = Ride {
            start: msg.start,
            end: msg.end,
            payment: msg.payment,
        };
        let ride_state = RideState::Searching(ride.clone());
        self.rides.insert(ride_id, (msg.passenger, 0, ride_state));
        let available_drivers: Vec<usize> = self
            .drivers_positions
            .iter()
            .filter_map(|(driver_id, driver_position)| {
                if is_proxim(msg.start, *driver_position) {
                    Some(*driver_id) // Si el conductor está cerca, incluir el driver_id
                } else {
                    None
                }
            })
            .collect();
        self.drivers_ask_in_ride
            .entry(ride_id)
            .or_default()
            .extend(available_drivers.clone());

        let rides_key_str = Box::new("rides".to_string());
        let rides_value_str = Box::new(serde_json::to_string(&self.rides).unwrap().to_string());
        let rides_key: &'static String = Box::leak(rides_key_str);
        let rides_value: &'static String = Box::leak(rides_value_str);

        let drivers_key_str = Box::new("drivers".to_string());
        let drivers_value_str = Box::new(serde_json::to_string(&self.rides).unwrap().to_string());
        let drivers_key: &'static String = Box::leak(drivers_key_str);
        let drivers_value: &'static String = Box::leak(drivers_value_str);

        let db_connection = Arc::clone(&self.db_connection);

        ctx.spawn(
            async move {
                db_connection
                    .lock()
                    .await
                    .set_key(rides_key, rides_value)
                    .await
                    .unwrap();

                db_connection
                    .lock()
                    .await
                    .set_key(drivers_key, drivers_value)
                    .await
                    .unwrap();
            }
            .into_actor(self),
        );
        ctx.address().do_send(GetDriver {
            passenger: msg.passenger,
            ride,
            ride_id,
        });
    }
}

impl Handler<RefusePayment> for ServerActor {
    type Result = ();

    fn handle(&mut self, msg: RefusePayment, _ctx: &mut Self::Context) {
        if let Some(passenger_addr) = self.passengers.get(&msg.passenger) {
            passenger_addr.do_send(InformState {
                state: ExternalMessage::RejectedPayment,
            });
        }
    }
}

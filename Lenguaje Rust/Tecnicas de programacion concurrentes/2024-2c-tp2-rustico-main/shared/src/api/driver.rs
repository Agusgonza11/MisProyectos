use crate::api::client;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub enum Request {
  /// Register at position (x, y)
  Register (u64, u64),
  /// Update position to (x, y)
  UpdatePosition (u64, u64),
  AcceptRide (client::RideID),
  Unregister
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RideOffer {
  id: client::RideID,
  details: client::RideDetails,
  payment: f64
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Response {
  Ok(),
  OfferGone(client::RideID),
  RideOffer(RideOffer)
}

pub type C2S = Request;
pub type S2C = Response;

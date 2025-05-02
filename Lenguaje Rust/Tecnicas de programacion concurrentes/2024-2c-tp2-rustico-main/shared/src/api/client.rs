use crate::api::payment;
use serde::{Deserialize, Serialize};


#[derive(Serialize, Deserialize, Debug)]
pub struct RideDetails {
  pub start: (u64, u64),
  pub end: (u64, u64)
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RideRequest {
  pub details: RideDetails,
  pub payment_details: payment::PaymentDetails
}

pub type RideID = u64;

#[derive(Serialize, Deserialize, Debug)]
pub enum Request {
  CreateRide(RideRequest),
  QueryRide(RideID)
}

#[derive(Serialize, Deserialize, Debug)]
pub enum RideFailReason {
  PaymentFailed,
  NoDrivers
}

#[derive(Serialize, Deserialize, Debug)]
pub enum RideStatus {
  RideFailed(RideFailReason),
  DriverEnRoute(u64, u64),
  ClientOnBoard
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Response {
  RideCreated(RideID),
  RideFailed(RideID, RideFailReason),
  RideStatus(RideID, RideStatus)
}

pub type C2S = Request;
pub type S2C = Response;

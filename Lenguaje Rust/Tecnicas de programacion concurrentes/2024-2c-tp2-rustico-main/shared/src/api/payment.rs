use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct PaymentDetails {
  pub card_number: String,
}

pub type TxID = String;

#[derive(Serialize, Deserialize, Debug)]
pub enum Request {
  StartPayment(PaymentDetails),
  QueryStatus(TxID)
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Response {
  PaymentPending(TxID)
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Notification {
  PaymentRejected(TxID),
  PaymentOK(TxID)
}

pub type C2S = Request;
#[derive(Serialize, Deserialize, Debug)]
pub enum S2C {
  Response(Response),
  Notification(Notification)
}
[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/GAOi0Fq-)

# 🚗 ConcuRide - Sistema de Transporte Colaborativo

## 📖 Introducción  
**ConcuRide** es una nueva aplicación para conectar conductores y pasajeros. Gracias a su inovadora implementación distribuida, permitirá reducir los costos y apuntar a ser líder en el mercado.  
Los pasajeros tendrán una app donde podrán elegir el destino, y los choferes una app donde recibirán y podrán aceptar o denegar viajes.  

## 🚀 Forma de Ejecución  

Para iniciar el sistema, sigue estos pasos en el orden indicado:

### Levantar el Servidor Principal  
Accede a la carpeta **`server`** y ejecuta:  
```bash
cargo run [puerto_pasajeros] [puerto_conductores] [puerto_gateway] [./config.json]
```
   
[puerto_pasajeros]: Puerto en el que escucha las solicitudes de los pasajeros.  
[puerto_conductores]: Puerto en el que escucha las solicitudes de los conductores.  
[puerto_gateway]: Puerto en el que interactúa con el gateway de pagos.
[config.json]: Archivo con las direcciones de las replicas de la base de datos
  
### Levantar la app de Gateway de pagos 
Accede a la carpeta **`payments`** y ejecuta:  
```bash
cargo run [puerto_gateway_server]
```
   
[puerto_gateway_server]: Puerto de conexión con el servidor principal.
  
### Levantar la app de Drivers

Accede a la carpeta **`drivers`** y ejecuta:  
```bash
cargo run [puerto_driver_server]
```

[puerto_driver_server]: Puerto de conexión con el servidor principal.


### Levantar la app de Passengers

Accede a la carpeta **`passengers`** y ejecuta:  
```bash
cargo run [puerto_passenger_server]
```

[puerto_passenger_server]: Puerto de conexión con el servidor principal.

> **Nota:** Obviamente el orden de ejecucion a la hora de crear un conductor o un pasajero es indistinto.

### Levantar la Base de Datos

Accede a la carpeta **`db/server`** y ejecuta:  
```bash
cargo run [config.N.json]
```

[config.N.json]: Archivo de configuración correspondiente

> **Nota:** Los archivos de ejemplo son para un cluster de 3 servidores. Si se desea editar los archivos o crear nuevos, se debe asegurar que todos tegan un identificador único, y que todos conozcan a sus pares.

# 📦 Sistema de Mensajes  

En **ConcuRide**, cada aplicación (Payments, Drivers, Passengers) utiliza estructuras definidas como MessageSend y MessageReceiver para enviar y recibir mensajes con el servidor principal. A continuación, se detallan las estructuras de mensajes y su funcionamiento para cada aplicación:

---

## 💳 Payments  
#### Estructuras de Mensajes  

**Mensajes Enviados (`MessageSend`):**
```rust
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
```
- **`Set`**:  
  Se envía apenas se levanta la aplicación para informar al servidor que el gateway de pagos ha sido inicializado correctamente.

- **`GatewayResponse`**:  
  Se utiliza para informar al servidor si el pago del pasajero fue aceptado o rechazado.  
  - **Probabilidad de Aceptación/Rechazo**:
    - 80% de probabilidad de aceptar el pago.
    - 20% de probabilidad de rechazar el pago.

**Mensajes Recibidos (`MessageReceiver`):**
```rust
pub enum MessageReceiver {
    AutorizePayment((u64, u64), (u64, u64), u64, usize),
}
```
- **`AutorizePayment`**:  
  Este mensaje es enviado por el servidor al gateway de pagos para autorizar el pago de un pasajero.
  - **Contiene los siguientes datos:**:
    - start y end: Coordenadas de inicio y fin del viaje, respectivamente.
    - payment: Monto del pago.
    - passenger_id: Identificador único del pasajero.

## 👤 Passengers  
#### Estructuras de Mensajes  

**Mensajes Enviados (`MessageSend`):**
```rust
pub enum MessageSend {
    CreateRide {
        start: (u64, u64),
        end: (u64, u64),
        payment: u64,
    }
}
```
- **`CreateRide`**:  
  Este mensaje se envía al servidor cuando el pasajero solicita un viaje.

**Mensajes Recibidos (`MessageReceiver`):**
```rust
pub enum MessageReceiver {
    RejectedPayment,
    SearchingDriver,
    NoDriversAvailable,
    OnWay,
    RideCompleted,
}
```
- **`RejectedPayment`**:  
  El servidor informa que el pago ha sido rechazado, y la aplicación debe cerrarse.
- **`SearchingDriver`**:  
  Se envía cuando el viaje ha sido creado exitosamente y el sistema está buscando un conductor.
- **`NoDriversAvailable`**:  
  Informa que no hay conductores disponibles para realizar el viaje. En este caso, la aplicación se cierra.
- **`OnWay`**:  
  Se recibe cuando un conductor ha aceptado el viaje y está en camino para recoger al pasajero.
- **`RideCompleted`**:  
  Informa que el viaje ha sido completado y el pasajero ha llegado a su destino.

## 🚗 Drivers  
#### Estructuras de Mensajes  

**Mensajes Enviados (`MessageSend`):**
```rust
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
```
- **`Register`**:  
  Se envía al levantar la aplicación para registrar al conductor en el sistema con su posición actual.

- **`DriverResponse`**:  
  Este mensaje se envía al servidor para responder a una oferta de viaje. Contiene un booleano que indica si el viaje se ha aceptado o no.

- **`DriverCompleteRide`**:  
  Se envía al servidor una vez que el conductor ha completado el viaje y ha terminado de manejar.
  
**Mensajes Recibidos (`MessageReceiver`):**
```rust
pub enum MessageReceiver{
    PaymentRide(u64),
    RideOffer(usize, usize, usize, u64),
    DriveToDestination((u64, u64), (u64, u64), u64, usize, usize, usize),
}
```
- **`PaymentRide`**:  
  Contiene el pago correspondiente recibido al finalizar el viaje.

- **`RideOffer`**:  
  Contiene una oferta de viaje que el conductor puede decidir si aceptar o no. La aceptará con una probabilidad de 80%, la rechazará con un 20%.

- **`DriveToDestination`**:  
  Cuando el servidor envía este mensaje, le está indicando al conductor que su aceptación de la oferta de viaje fue exitosa y que puede comenzar su trayecto.

# 🖥️ Server  

El servidor funciona como coordinador, modelando todas las entidades con el modelo de actores. En `main`, el servidor lanza un `tokio::spawn(handle_client)` por cada conexión que recibe, y luego crea un `serverActor`, que será el coordinador principal entre todos los diferentes actores. La información sobre los conductores, pasajeros, y viajes la va a tomar inicialmente de la base de datos. A medida que recibe nuevas conexiones de conductores, pasajeros, y nuevas solicitudes de viajes, guarda esa información en la base de datos. También va a crear los siguientes actores:

- `PassengerActor`
- `DriverActor`
- `PaymentActor`

Cada uno de estos actores será modelado y se comunicará entre sí mediante los siguientes mensajes y comportamientos.
> **Nota:** Estos tres actores (PassengerActor, DriverActor, PaymentActor) tendrán un canal (`channel`) que envía un `ExternalMessage`. Estos son senders conectados a un receiver que, de manera asincrónica, enviará las respuestas a las aplicaciones. Los `ExternalMessage` son los mensajes ya especificados y explicados anteriormente.

A continuación, se detallan los mensajes que se envían entre estos actores y su comportamiento:
  
# 🧑‍💼 Actores:  
## 💳 PaymentsActor  
```rust
pub struct PaymentsActor {
    pub server: Addr<ServerActor>,
    pub sender: Sender<ExternalMessage>,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct AutorizePayment {
    pub ride: CreateRide,
    pub passenger_id: usize,
}
```
- **`AutorizePayment`**:  
  Este mensaje recibe la solicitud para autorizar el pago de un viaje creado. Toma la orden y la envía directamente a la aplicación de gateway para procesar el pago.

## 👤 Passengers 
```rust
pub struct PassengerActor {
    pub id: usize,
    pub position: (u64, u64),
    pub server: Addr<ServerActor>,
    pub sender: Sender<ExternalMessage>,
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct InformState {
    pub state: ExternalMessage
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct CreateRide {
    pub start: (u64, u64),
    end: (u64, u64),
    payment: u64,
}
```
- **`InformState`**:  
  Este mensaje recibe el estado del viaje solicitado y se encarga de enviarselo a la aplicacion de Passenger.

- **`CreateRide`**:  
  Este mensaje recibe la posicion del inicio del viaje y la setea como la posicion actual del pasajero.

## 🚗 DriverActor
```rust
pub struct DriverActor {
    pub id: usize,
    pub position: (u64, u64),
    pub server: Addr<ServerActor>,
    pub sender: Sender<ExternalMessage>,
    pub available: bool,
}

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
```
- **`Register`**:  
  Con este mensaje se inicializa la posicion del conductor

- **`RideOffer`**:  
  Este mensaje recibe una solicitud de viaje cercano, de encontrarse disponible (no estar realizando ningun otro viaje) se envia la solicitud a la app del Driver. 

- **`Drive`**:  
  Con este mensaje recibe la orden de comenzar el viaje, se declara como no disponible y le envia a la app de Driver la orden de comenzar el trayecto.

- **`GetPay`**:  
  Con este mensaje se declara nuevamente como disponible para realizar otro viaje, y recibe el pago el cual se lo reenviara a su app de Driver para informarlo.

## 🖥️ ServerActor

Como ya mencionamos, este actor funcionara como el cordinador entre el resto de los actores.

---

```rust
pub struct ServerActor {
    drivers: HashMap<usize, Addr<DriverActor>>,
    drivers_positions: HashMap<usize, (u64, u64)>,
    passengers: HashMap<usize, Addr<PassengerActor>>,
    rides: HashMap<usize, (usize, usize, RideState)>,
    drivers_ask_in_ride: HashMap<usize, Vec<usize>>,
    last_driver: usize,
    last_passenger: usize,
    last_ride: usize,
    payment_gatewey_addr: Option<Addr<PaymentsActor>>,
}

pub enum RideState {
    Searching(Ride),
    Accepted(Ride),
    Completed(Ride),
    Canceled(()),
}

pub struct Ride {
    pub start: (u64, u64),
    pub end: (u64, u64),
    pub payment: u64,
}
```
Esta es su estructura, ademas de que es interesante mostrar los diferentes estados que puede tomar un viaje (Ride). A continuacion se muestran sus mensajes.  
```rust
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
```
- **`CreatePaymentsSystem`**:  
  Con este mensaje, simplemente se crea un nuevo actor PaymentsActor y se añade al sistema.

- **`CreatePassenger`**:  
  Se crea un nuevo PassengerActor que se añade al sistema, y le envia al actor PaymentsActor un mensaje AutorizePayment para que autorice el pago por el viaje que solicita el pasajero.

- **`CreateDriver`**:  
  Se crea un nuevo DriverActor que se añade al sistema. Tambien comprueba si no hay viajes pendientes buscando conductores, y en caso que asi sea (RideState = Searching) le envia un RideOffer, esto considerando el caso de que se conecte un pasajero y solicite un viaje antes que un conductor se registre.

```rust
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
    pub payment: u64
}
```
- **`RefusePayment`**:  
  Se le envia un mensaje InformState al PassengerActor indicando que el pago fue rechazado por la app Gateway.

- **`AcceptPayment`**:  
  Crea un nuevo Ride y lo añade al sistema, tambien obtiene y guarda una lista de los id de drivers cercanos a la posicion respecto al viaje solicitado. Finalmente le envia un mensaje GetDriver al propio ServerActor indicando que tiene que conseguir un Driver para ese Ride.

```rust
#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct GetDriver {
    pub passenger: usize,
    pub ride: Ride,
    pub ride_id: usize,
}
```
- **`GetDriver`**:  
  Toma uno de los conductores cercanos a la posicion del viaje y le envia un mensaje RideOffer, luego elimina ese id de la lista de conductores cercanos a ese viaje, en el caso de que dicha lista se encuentre vacia (no hay conductores disponibles) le envia un mensaje InformState al PassengerActor indicandole que no hay conductores disponibles en este momento, ademas setea el estado del viaje como Canceled en el sistema. 

```rust
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
```
- **`AcceptRide`**:  
  Recibe este mensaje de la app de Driver indicando que el viaje fue aceptado por el conductor. Primero le envia un mensaje InformState al PassengerActor indicandole que el conductor va en camino. Luego cambia el estado del Ride a Accepted en el sistema y le envia al DriverActor un mensaje Drive para indicarle que comience su trayecto.

- **`RefuseRide`**:  
  Este mensaje reenvia el mensaje GetDriver al ServerActor, esto para manejar el caso en que si bien un conductor rechazo la oferta, todavia pueden haber otros cercanos y dispuestos a aceptarla. 

```rust
#[derive(Message, Debug)]
#[rtype(result = "()")]
pub struct CompleteRide {
    pub passenger: usize,
    pub ride_id: usize,
    pub driver_id: usize,
    pub payment: u64,
}
```
- **`CompleteRide`**:  
  Primero le envia un mensaje InformState al PassengerActor indicandole que el viaje se ha completado. Luego le envia un mensaje GetPay al DriverActor para informarle que le hace la entrega de su pago. Finalmente setea la posicion del conductor como la del fin del viaje y cambia el estado del mismo a Completed.

# 🗃️ Base De Datos

Para la base de datos, se utiliza el protocolo [Raft](https://en.wikipedia.org/wiki/Raft_(algorithm)).

Para demostrar su funcionamiento, los timings son substancialmente superiores a los que se usarían en la práctica.

## Terminos

Hay un par de términos que vale la pena aclarar:

mandato: Un "numero de elección". Solo el mayor de los mandatos es el actualmente válido.

log: operación realizada, incluyendo en que mandato se realizó

KV: clave-valor, un diccionario

commiteada: si se cumplen las condiciones de durabilidad (ver Garantías), se garantiza que no se va a deshacer

## Garantías

Las operaciones son ejecutadas de manera secuencial y atómica (a nivel de operación).

Se elije la consistencia por sobre la disponibilidad, por lo cual solo se ofrece servicio cuando existe una mayoría de nodos para dar quorum.

Durante un mandato solo puede existir un líder.

Raft provee garantías de durabilidad si se persiste a almacenamiento durable antes de responder cada RPC. Para demostrar las capacidades de replicación, esto esta deshabilitado. Por esto solo se garantiza durabilidad si la mayoría de los nodos tienen el log correspondiente.

## Elecciones

Cuando un nodo no recibe nada del lider ni de otros candidatos, comienza una elección.

Para hacer esto, aumenta el contador de mandato y pide a todos los nodos que lo voten. Estos nodos actualizan su valor de mandato, por lo cual incluso si el líder anterior volviese, sería ignorado.

Los nodos solo pueden votar a un nodo por mandato, y demandan que este no este atrasado con los logs (esto es para evitar que se pierdan datos).

Para ganar la elección se necesita la mayoría de los votos. Esto es para evitar que existan dos líderes en el mismo mandato.

Si no se puede concretar la elección, se espera una cantidad aleatoria de tiempo y se vuelve a intentar.

Si en cualquier momento es notificado de la existencia de un nuevo lider, pasa a seguirlo.

## Máquina de Estados

Para abstraer la logica de replicación y consenso de los detalles de los datos, se modela la base de datos como una máquina de estados que recibe como entrada operaciones, y que tiene asociada una función que permite hacer consultas.

En este caso para implementar un store KV se tienen las siguientes entradas:

- SetKey(key: String, value: String)
- DelKey(key: String)

Para permitir consultas, se implementa una función de consulta, que en este caso consiste de consulta de claves:

- GetKey(key: String): String

Cuando la mayoría de los nodos contiene la operación, esta es considerada como commiteada. El líder lo sabe cuando la mitad de los nodos contestó el AppendEntries exitosamente. Los follower son notificados con el `leaderCommit` de AppendEntries

## Mensajes

### AppendEntries

Se envía para sincronizar operaciones o como heartbeat para evitar timeouts.

Informa a un seguidor:
- Que el nodo mandando el mensaje es el lider para el mandato `term`
- La posición por sobre la cual va a agregar entradas
- Las entradas a agregar, o ninguna si es un heartbeat
- El ultimo log que cumple la condición de commit (replicado a la mayoría de los nodos)

En caso de que el nodo no tenga el log que se asume como base, devuelve error y el lider reintenta con logs anteriores.

```rust
pub struct AppendEntriesRequest<Op> {
  pub term: u64,
  pub leaderId: u64,
  pub prevLogIndex: i64,
  pub prevLogTerm: u64,
  pub entries: Vec<Entry<Op>>,
  pub leaderCommit: i64
}
pub struct AppendEntriesResponse {
  pub term: u64,
  pub sucess: bool
}
```

### RequestVote

Pide el voto. Es otorgado si (para el mismo mandato) no se votó a otro nodo, y los logs del que pide el voto no estan desactualizados.

```rust
pub struct RequestVoteRequest {
  pub term: u64,
  pub candidateId: u64,
  pub lastLogIndex: u64,
  pub lastLogTerm: u64
}
pub struct RequestVoteResponse {
  pub term: u64,
  pub voteGranted: bool
}
```

### ClientRequest

Este RPC contiene pedidos de operación sobre la base de datos. Estos estan divididos en dos tipos: operaciones y consultas.

Las operaciones son aquellas que involucran cambios a la base de datos, y las consultas las que no.

En el caso de que el nodo sea el lider, se 

En caso de que el nodo consultado no sea el líder, se devuelve el id del líder para que el cliente le pregunte.

En caso de que no hay líder definido (success=false y leaderId=None), el cliente debe probar en otros clientes hasta que uno conozca el líder o que se restaure el quorum.

```rust
pub enum ClientRequest<Q, Op> {
  Query(Q),
  Operation(Op)
}

pub struct ClientResponse<Res> {
  pub sucess: bool,
  pub leaderId: Option<u64>,
  pub response: Option<Res>
}
```


# 📓 Casos de Interés

## ✅ Casos Felices

a. **Viaje completado exitosamente**
   - El pasajero solicita un viaje, se autoriza su pago, un conductor acepta la solicitud, simula su tiempo de viaje y deja al pasajero en su destino recibiendo a si mismo el pago por su servicio, se cierra la app de pasajeros y el conductor esta disponible para aceptar nuevos viajes, ahora desde su nueva posicion.

b. **Viaje rechazado por conductores pero aceptado por otros**
   - Después de enviar a varios conductores la oferta de viaje y que lo rechacen, se fueron eliminando de la lista de conductores disponibles hasta que acepto y procede a realizar el mismo.

c. **Conductor Registrado Correctamente**
   - Al iniciar la aplicación, el conductor se registra con su ubicación y está listo para recibir ofertas de viaje. La aplicación registra correctamente la posición y el conductor está disponible para aceptar viajes.

## ❌ Casos con Fallas

a. **Pago Rechazado**
   - La app Gateway de pagos rechaza el pago del pasajero, por lo que el viaje se cancela y se cierra la app Passenger

b. **Viaje Rechazado por todos los conductores**
   - Todos los conductores cercanos a la posicion del pasajero rechazan el viaje, por lo que el pasajero recibe un mensaje indicando que no hay conductores disponibles y se cierra su app.

c. **Viaje Rechazado por no haber conductores cerca**
   - No hay ningun conductor cercano al pasajero, por lo que éste recibe un mensaje indicando que no hay conductores disponibles y se cierra su app.


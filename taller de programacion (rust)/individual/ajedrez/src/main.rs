use ajedrez::errores::*;
use ajedrez::juego::Juego;
use ajedrez::tablero::Tablero;
use std::env;
use std::fs;

/// Abre el archivo ingresado por entrada estandard
///
/// Devuelve un string ya sea indicando que no se pudo abrir el mismo o con su contenido
fn abrir_archivo() -> String {
    let args: Vec<String> = env::args().collect();
    let archivo = fs::read_to_string(&args[1]);
    match archivo {
        Err(_e) => "ERROR: No se encontro el archivo o el directorio".to_string(),
        Ok(v) => v,
    }
}

///Funcion main del programa
///
/// Primero abre el archivo indicado por entrada estandard, a continuacion
/// crea un Tablero con el contenido del mismo, si no ocurrio ningun error
/// durante la creacion del tablero crea las Piezas agregandolas al Juego
/// para que este obtenga el ganador
fn main() {
    let contenido = abrir_archivo();
    if contenido.contains("ERROR") {
        return println!("{}", contenido);
    }
    let tablero = Tablero::llenar_tablero(contenido);
    match tablero {
        Err(e) => {
            println!("ERROR: {}", imprimir_error(e));
        }
        Ok(t) => {
            let (blanca, negra) = t.obtener_piezas();
            let juego = Juego {
                pieza_blanca: blanca,
                pieza_negra: negra,
            };
            println!("{}", juego.obtener_ganador());
        }
    }
}

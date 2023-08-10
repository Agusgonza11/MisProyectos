extern crate ajedrez;

use ajedrez::errores::*;
use ajedrez::juego::*;
use ajedrez::tablero::*;

#[test]
fn test_empate_entre_peones() {
    let mapa = "_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ P _ _ _ _ _\n_ _ _ p _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n".to_string();
    let tablero = Tablero::llenar_tablero(mapa);
    match tablero {
        Err(_) => {}
        Ok(t) => {
            let (blanca, negra) = t.obtener_piezas();
            let juego = Juego {
                pieza_blanca: blanca,
                pieza_negra: negra,
            };
            assert_eq!(juego.obtener_ganador(), "E");
        }
    }
}

#[test]
fn test_tablero_invalido() {
    let mapa = "_ _ _ _ _ _ _ _\n_ _ _ _ _ D _ _\n_ _ __ _ _ _\n_ _ _ p _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n".to_string();
    let tablero = Tablero::llenar_tablero(mapa);
    match tablero {
        Err(e) => {
            assert_eq!(
                imprimir_error(e),
                "El formato del tablero ingresado es invalido"
            );
        }
        Ok(_) => {}
    }
}

#[test]
fn test_blancas_incorrectas() {
    let mapa = "_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ P _ _ _ _ _\n_ _ _ p _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ t _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n".to_string();
    let tablero = Tablero::llenar_tablero(mapa);
    match tablero {
        Err(e) => {
            assert_eq!(
                imprimir_error(e),
                "La cantidad de piezas blancas ingresadas es invalida"
            );
        }
        Ok(_) => {}
    }
}

#[test]
fn test_negras_incorrectas() {
    let mapa = "_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ t _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n".to_string();
    let tablero = Tablero::llenar_tablero(mapa);
    match tablero {
        Err(e) => {
            assert_eq!(
                imprimir_error(e),
                "La cantidad de piezas negras ingresadas es invalida"
            );
        }
        Ok(_) => {}
    }
}

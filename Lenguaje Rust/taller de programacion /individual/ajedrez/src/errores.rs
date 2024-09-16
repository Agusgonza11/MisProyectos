#[derive(Debug)]
/// Todos los errores que pueden llegar a ocurrir en el programa
pub enum ErrorAjedrez {
    /// Este ocurre cuando el formato del tablero no es valido
    FormatoInvalidoDeTablero,
    /// Este ocurre cuando la cantidad de piezas blancas es menor o mayor a uno
    CantidadIncorrectaDeBlancas,
    /// Este ocurre cuando la cantidad de piezas negras es menor o mayor a uno
    CantidadIncorrectaDeNegras,
}

/// De acuerdo al tipo de error ocurrido devuelve su respectivo mensaje de error
pub fn imprimir_error(error: ErrorAjedrez) -> String {
    match error {
        ErrorAjedrez::FormatoInvalidoDeTablero => {
            "El formato del tablero ingresado es invalido".to_string()
        }
        ErrorAjedrez::CantidadIncorrectaDeBlancas => {
            "La cantidad de piezas blancas ingresadas es invalida".to_string()
        }
        ErrorAjedrez::CantidadIncorrectaDeNegras => {
            "La cantidad de piezas negras ingresadas es invalida".to_string()
        }
    }
}

#[cfg(test)]
mod test_errores {
    use super::*;

    #[test]
    fn test_imprimir_error_formato() {
        assert_eq!(
            imprimir_error(ErrorAjedrez::FormatoInvalidoDeTablero),
            "El formato del tablero ingresado es invalido".to_string()
        );
    }

    #[test]
    fn test_imprimir_error_blancas() {
        assert_eq!(
            imprimir_error(ErrorAjedrez::CantidadIncorrectaDeBlancas),
            "La cantidad de piezas blancas ingresadas es invalida".to_string()
        );
    }

    #[test]
    fn test_imprimir_error_negras() {
        assert_eq!(
            imprimir_error(ErrorAjedrez::CantidadIncorrectaDeNegras),
            "La cantidad de piezas negras ingresadas es invalida".to_string()
        );
    }
}

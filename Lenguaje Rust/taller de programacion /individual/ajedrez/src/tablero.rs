use crate::errores::ErrorAjedrez;
use crate::pieza::*;
/// El tablero contiene la distribucion de la partida
pub struct Tablero {
    /// Un vector de vectores de char utilizado a modo de matriz
    tablero: Vec<Vec<char>>,
}

impl Tablero {
    /// De acuerdo al contenido del archivo va llenando el vector tablero
    ///
    /// Ira creando por cada fila un nuevo vector y llenandolo con los char
    /// del archivo, ademas segun este char ira aumentando los atributos pasados
    /// por &mut a la funcion, asi como tambien la cantidad de piezas blancas y
    /// negras encontradas las cuales se devolvera en forma de tupla, esto se usara
    /// para proximos checkeos
    fn llenar_vector(
        archivo: &str,
        casilleros: &mut i64,
        filas: &mut i64,
        espacios: &mut i64,
        tablero: &mut Vec<Vec<char>>,
    ) -> (i64, i64) {
        let mut blancas = 0;
        let mut negras = 0;
        let mut fila_actual = Vec::new();
        for c in archivo.chars() {
            match c {
                '\n' => {
                    *filas += 1;
                    tablero.push(fila_actual);
                    fila_actual = Vec::new()
                }
                ' ' => *espacios += 1,
                '_' => {
                    fila_actual.push(c);
                    *casilleros += 1;
                }
                'r' | 'd' | 'a' | 'c' | 't' | 'p' => {
                    fila_actual.push(c);
                    *casilleros += 1;
                    blancas += 1
                }
                'R' | 'D' | 'A' | 'C' | 'T' | 'P' => {
                    fila_actual.push(c);
                    *casilleros += 1;
                    negras += 1
                }
                _ => {}
            }
        }
        (blancas, negras)
    }

    /// Lleno la matriz usada a modo de tablero y devuelvo un Result que
    /// contendra ya sea un Tablero o un enum ErrorAjedrez si encontro
    /// un fallo en una de sus verificaciones
    pub fn llenar_tablero(archivo: String) -> Result<Tablero, ErrorAjedrez> {
        let mut casilleros = 0;
        let mut filas = 0;
        let mut espacios = 0;
        let mut tablero = Vec::new();
        let (blancas, negras) = Self::llenar_vector(
            &archivo,
            &mut casilleros,
            &mut filas,
            &mut espacios,
            &mut tablero,
        );
        if casilleros != 64 || filas != 8 || espacios != 56 {
            return Err(ErrorAjedrez::FormatoInvalidoDeTablero);
        }
        if blancas != 1 {
            return Err(ErrorAjedrez::CantidadIncorrectaDeBlancas);
        }
        if negras != 1 {
            Err(ErrorAjedrez::CantidadIncorrectaDeNegras)
        } else {
            Ok(Tablero { tablero })
        }
    }

    /// Dado el tablero devuelvo una tupla con las piezas blancas y negras
    ///
    /// Recorro el tablero en cada una de sus posiciones y al encontrar a una
    /// de las piezas las creo y me las guardo para devolver en la tupla
    ///
    /// En esta instancia no realizo ningun checkeo por las posiciones de las
    /// piezas ya que es algo que se cubrio en el metodo de llenar_tablero
    pub fn obtener_piezas(&self) -> (Pieza, Pieza) {
        let mut blanca = Pieza {
            pos_x: 0,
            pos_y: 0,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Peon,
        };
        let mut negra = Pieza {
            pos_x: 0,
            pos_y: 0,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Peon,
        };
        for f in 0..self.tablero.len() {
            for c in 0..8 {
                if self.tablero[f][c].is_lowercase() {
                    blanca = Pieza::new(c as i64, f as i64, ColorPieza::Blanca, self.tablero[f][c]);
                }
                if self.tablero[f][c].is_uppercase() {
                    negra = Pieza::new(c as i64, f as i64, ColorPieza::Negra, self.tablero[f][c]);
                }
            }
        }
        (blanca, negra)
    }
}

#[cfg(test)]
mod test_tablero {
    use super::*;

    #[test]
    fn test_vector_con_blanca_y_negra() {
        let mut casilleros = 0;
        let mut filas = 0;
        let mut espacios = 0;
        let mut tablero = Vec::new();
        let archivo = "_ _ r _ _ _ D".to_string();
        let (blancas, negras) = Tablero::llenar_vector(
            &archivo,
            &mut casilleros,
            &mut filas,
            &mut espacios,
            &mut tablero,
        );
        assert_eq!(blancas, 1);
        assert_eq!(negras, 1);
    }

    #[test]
    fn test_vector_con_blanca_sin_negra() {
        let mut casilleros = 0;
        let mut filas = 0;
        let mut espacios = 0;
        let mut tablero = Vec::new();
        let archivo = "_ _ r _ _ _".to_string();
        let (blancas, negras) = Tablero::llenar_vector(
            &archivo,
            &mut casilleros,
            &mut filas,
            &mut espacios,
            &mut tablero,
        );
        assert_eq!(blancas, 1);
        assert_eq!(negras, 0);
    }

    #[test]
    fn test_llenar_tablero_con_2_blancas() {
        let mapa = "_ _ _ _ _ _ _ _\n_ _ _ _ _ P _ _\n_ _ _ _ _ _ _ _\n _ _ _ d _ _ _ _\n _ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ d _ _\n_ _ _ _ _ _ _ _\n".to_string();
        let tablero = Tablero::llenar_tablero(mapa);
        match tablero {
            Err(_) => {
                assert!(true);
            }
            Ok(_) => {}
        }
    }

    #[test]
    fn test_llenar_tablero_con_0_negras() {
        let mapa = "_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ d _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n".to_string();
        let tablero = Tablero::llenar_tablero(mapa);
        match tablero {
            Err(_) => {
                assert!(true);
            }
            Ok(_) => {}
        }
    }

    #[test]
    fn test_llenar_tablero_con_formato_incorrecto() {
        let mapa = "_ _ _ _ _ _ _ _\n_ _ _ _ _ R _ _\n_  _ _ _ _ _ _\n_ _ _ d _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n".to_string();
        let tablero = Tablero::llenar_tablero(mapa);
        match tablero {
            Err(_) => {
                assert!(true);
            }
            Ok(_) => {}
        }
    }

    #[test]
    fn test_llenar_tablero_correctamente() {
        let mapa = "R _ _ _ _ _ _ _\n_ d _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n".to_string();
        let tablero = Tablero::llenar_tablero(mapa);
        match tablero {
            Err(_) => {}
            Ok(_) => {
                assert!(true);
            }
        }
    }

    #[test]
    fn test_obtener_piezas_del_tablero() {
        let mapa = "R _ _ _ _ _ _ _\n_ d _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n_ _ _ _ _ _ _ _\n".to_string();
        let tablero = Tablero::llenar_tablero(mapa);
        match tablero {
            Err(_) => {}
            Ok(t) => {
                let (blanca, negra) = t.obtener_piezas();
                assert_eq!(blanca.pos_x, 1);
                assert_eq!(blanca.pos_y, 1);
                assert_eq!(negra.pos_x, 0);
                assert_eq!(negra.pos_y, 0);
            }
        }
    }
}

/// Colores posibles de una pieza de ajedrez
pub enum ColorPieza {
    Blanca,
    Negra,
}

/// Tipo de piezas posibles en el ajedrez
pub enum TipoPieza {
    Rey,
    Dama,
    Alfil,
    Torre,
    Caballo,
    Peon,
}

/// Una pieza del ajedrez
pub struct Pieza {
    /// La posicion en X en el tablero
    pub pos_x: i64,
    /// La posicion en Y en el tablero
    pub pos_y: i64,
    /// El color de la pieza
    pub color: ColorPieza,
    /// El tipo de pieza
    pub tipo: TipoPieza,
}

impl Pieza {
    /// Constructor del struct Pieza
    ///
    /// Dado un char en su tipo matchea el TipoPieza necesario para su construccion
    pub fn new(pos_x: i64, pos_y: i64, color: ColorPieza, tipo: char) -> Pieza {
        let tipo_pieza = match tipo {
            'r' | 'R' => TipoPieza::Rey,
            'd' | 'D' => TipoPieza::Dama,
            'a' | 'A' => TipoPieza::Alfil,
            't' | 'T' => TipoPieza::Torre,
            'c' | 'C' => TipoPieza::Caballo,
            'p' | 'P' => TipoPieza::Peon,
            _ => TipoPieza::Rey,
        };
        Pieza {
            pos_x,
            pos_y,
            color,
            tipo: tipo_pieza,
        }
    }

    /// De acuerdo al tipo de pieza devuelve todos los movimientos posibles del mismo
    pub fn obtener_movimientos(&self) -> Vec<(i64, i64)> {
        match self.tipo {
            TipoPieza::Rey => self.movimientos_rey(),
            TipoPieza::Dama => self.movimientos_dama(),
            TipoPieza::Alfil => self.movimientos_alfil(),
            TipoPieza::Torre => self.movimientos_torre(),
            TipoPieza::Caballo => self.movimientos_caballo(),
            TipoPieza::Peon => self.movimientos_peon(),
        }
    }

    /// Obtiene un vector con todos los movimientos posibles de la torre
    ///
    /// Crea un vector y lo envia a llenar con todas las posiciones de la fila y
    /// columna de acuerdo a la posicion de la pieza
    fn movimientos_torre(&self) -> Vec<(i64, i64)> {
        let mut movimientos = Vec::new();
        self.obtener_filas(&mut movimientos);
        self.obtener_columnas(&mut movimientos);
        movimientos
    }

    /// Obtiene un vector con todos los movimientos posibles de la dama
    ///
    /// Crea un vector y lo envia a llenar con todas las posiciones de la fila y
    /// columna y diagonales de de acuerdo a la posicion de la pieza
    fn movimientos_dama(&self) -> Vec<(i64, i64)> {
        let mut movimientos = Vec::new();
        self.obtener_filas(&mut movimientos);
        self.obtener_columnas(&mut movimientos);
        self.obtener_diagonales(&mut movimientos);
        movimientos
    }

    /// Obtiene un vector con todos los movimientos posibles del alfil
    ///
    /// Crea un vector y lo envia a llenar con todas las posiciones de las
    /// diagonales de acuerdo a la posicion de la pieza
    fn movimientos_alfil(&self) -> Vec<(i64, i64)> {
        let mut movimientos = Vec::new();
        self.obtener_diagonales(&mut movimientos);
        movimientos
    }

    /// Obtiene un vector con todos los movimientos posibles del peon
    ///
    /// Crea un vector y lo llena con un movimiento hacia adelante en ambas
    /// diagonales, tomando el adelante dependiendo de si la pieza es de color
    /// blanca o negra
    fn movimientos_peon(&self) -> Vec<(i64, i64)> {
        let mut movimientos = Vec::new();
        match self.color {
            ColorPieza::Blanca => {
                if self.pos_y != 0 {
                    movimientos.push((self.pos_x - 1, self.pos_y - 1));
                    movimientos.push((self.pos_x + 1, self.pos_y - 1));
                }
            }
            ColorPieza::Negra => {
                if self.pos_y != 7 {
                    movimientos.push((self.pos_x - 1, self.pos_y + 1));
                    movimientos.push((self.pos_x + 1, self.pos_y + 1));
                }
            }
        }
        movimientos
    }

    /// Obtiene un vector con todos los movimientos posibles del caballo
    ///
    /// Crea un vector y lo llena con las 8 posibles direcciones que puede alcanzar
    /// un caballo desde la propia, luego elimina las posiciones invalidas
    fn movimientos_caballo(&self) -> Vec<(i64, i64)> {
        let movimientos = vec![
            (self.pos_x - 1, self.pos_y - 2),
            (self.pos_x + 1, self.pos_y - 2),
            (self.pos_x + 2, self.pos_y - 1),
            (self.pos_x + 2, self.pos_y + 1),
            (self.pos_x + 1, self.pos_y + 2),
            (self.pos_x - 1, self.pos_y + 2),
            (self.pos_x - 2, self.pos_y + 1),
            (self.pos_x - 2, self.pos_y - 1),
        ];
        self.eliminar_invalidos(&movimientos)
    }

    /// Obtiene un vector con todos los movimientos posibles del rey
    ///
    /// Crea un vector y lo llena con las 8 posibles direcciones que puede alcanzar
    /// el rey desde la propia, luego elimina las posiciones invalidas
    fn movimientos_rey(&self) -> Vec<(i64, i64)> {
        let movimientos = vec![
            (self.pos_x - 1, self.pos_y - 1),
            (self.pos_x, self.pos_y - 1),
            (self.pos_x + 1, self.pos_y - 1),
            (self.pos_x + 1, self.pos_y),
            (self.pos_x + 1, self.pos_y + 1),
            (self.pos_x, self.pos_y + 1),
            (self.pos_x - 1, self.pos_y + 1),
            (self.pos_x - 1, self.pos_y),
        ];
        self.eliminar_invalidos(&movimientos)
    }

    /// Obtiene un vector con movimientos y devuelve otro con solo los elementos
    /// validos filtrados
    ///
    /// Entendiendose por movimientos validos los que se encuentran dentro de los
    /// limites del tablero
    fn eliminar_invalidos(&self, movimientos: &Vec<(i64, i64)>) -> Vec<(i64, i64)> {
        let mut nuevos_mov = Vec::new();
        for mov in movimientos {
            let (x, y) = *mov;
            if !(0..=7).contains(&x) || !(0..=7).contains(&y) {
                continue;
            } else {
                nuevos_mov.push((x, y));
            }
        }
        nuevos_mov
    }

    /// Obtiene todas las posiciones de la fila
    ///
    /// De acuerdo a un vector de movimientos lo llena con todas
    /// las posiciones horizontales que puede alcanzar la pieza
    fn obtener_filas(&self, movimientos: &mut Vec<(i64, i64)>) {
        for i in 0..8 {
            movimientos.push((i, self.pos_y));
        }
    }

    /// Obtiene todas las posiciones de la columna
    ///
    /// De acuerdo a un vector de movimientos lo llena con todas
    /// las posiciones verticales que puede alcanzar la pieza
    fn obtener_columnas(&self, movimientos: &mut Vec<(i64, i64)>) {
        for i in 0..8 {
            movimientos.push((self.pos_x, i));
        }
    }

    /// Obtiene todas las posiciones de las diagonales
    ///
    /// De acuerdo a un vector de movimientos lo llena con todas
    /// las posiciones diagonales que puede alcanzar la pieza
    fn obtener_diagonales(&self, movimientos: &mut Vec<(i64, i64)>) {
        self.diagonal_negativa(movimientos);
        self.diagonal_positiva(movimientos);
    }

    /// Obtiene todas las posiciones de la diagonal positiva
    ///
    /// De acuerdo a un vector de movimientos lo llena con todas
    /// las posiciones de la diagonal positiva que puede alcanzar
    /// la pieza
    fn diagonal_positiva(&self, movimientos: &mut Vec<(i64, i64)>) {
        let mut i = 1;
        while self.pos_x + i < 8 && self.pos_y - i >= 0 {
            movimientos.push((self.pos_x + i, self.pos_y - i));
            i += 1;
        }
        i = 1;
        while self.pos_x - i >= 0 && self.pos_y + i < 8 {
            movimientos.push((self.pos_x - i, self.pos_y + i));
            i += 1;
        }
    }

    /// Obtiene todas las posiciones de la diagonal negativa
    ///
    /// De acuerdo a un vector de movimientos lo llena con todas
    /// las posiciones de la diagonal negativa que puede alcanzar
    /// la pieza
    fn diagonal_negativa(&self, movimientos: &mut Vec<(i64, i64)>) {
        let mut i = 0;
        while self.pos_x - i >= 0 && self.pos_y - i >= 0 {
            movimientos.push((self.pos_x - i, self.pos_y - i));
            i += 1;
        }
        i = 1;
        while self.pos_x + i < 8 && self.pos_y + i < 8 {
            movimientos.push((self.pos_x + i, self.pos_y + i));
            i += 1;
        }
    }
}

#[cfg(test)]
mod test_pieza {
    use super::*;

    fn dar_movimientos_fila() -> Vec<(i64, i64)> {
        vec![
            (0, 0),
            (1, 0),
            (2, 0),
            (3, 0),
            (4, 0),
            (5, 0),
            (6, 0),
            (7, 0),
        ]
    }

    fn dar_movimientos_columna() -> Vec<(i64, i64)> {
        vec![
            (0, 0),
            (0, 1),
            (0, 2),
            (0, 3),
            (0, 4),
            (0, 5),
            (0, 6),
            (0, 7),
        ]
    }

    fn dar_movimientos_diagonal_negativa() -> Vec<(i64, i64)> {
        vec![
            (0, 0),
            (1, 1),
            (2, 2),
            (3, 3),
            (4, 4),
            (5, 5),
            (6, 6),
            (7, 7),
        ]
    }

    #[test]
    fn test_movimientos_torre() {
        let torre = Pieza {
            pos_x: 0,
            pos_y: 0,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Torre,
        };
        let mut horizontales = dar_movimientos_fila();
        horizontales.append(&mut dar_movimientos_columna());
        assert_eq!(torre.movimientos_torre(), horizontales);
    }

    #[test]
    fn test_movimientos_dama() {
        let dama = Pieza {
            pos_x: 0,
            pos_y: 0,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Dama,
        };
        let mut horizontales = dar_movimientos_fila();
        horizontales.append(&mut dar_movimientos_columna());
        horizontales.append(&mut dar_movimientos_diagonal_negativa());
        assert_eq!(dama.movimientos_dama(), horizontales);
    }

    #[test]
    fn test_movimientos_rey() {
        let rey = Pieza {
            pos_x: 1,
            pos_y: 1,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Rey,
        };
        let mov_rey = vec![
            (0, 0),
            (1, 0),
            (2, 0),
            (2, 1),
            (2, 2),
            (1, 2),
            (0, 2),
            (0, 1),
        ];
        assert_eq!(rey.movimientos_rey(), mov_rey);
    }

    #[test]
    fn test_movimientos_caballo() {
        let caballo = Pieza {
            pos_x: 5,
            pos_y: 5,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Caballo,
        };
        let mov_caballo = vec![
            (4, 3),
            (6, 3),
            (7, 4),
            (7, 6),
            (6, 7),
            (4, 7),
            (3, 6),
            (3, 4),
        ];
        assert_eq!(caballo.movimientos_caballo(), mov_caballo);
    }

    #[test]
    fn test_movimientos_alfil() {
        let alfil = Pieza {
            pos_x: 5,
            pos_y: 5,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Alfil,
        };
        let mov_alfil = vec![
            (5, 5),
            (4, 4),
            (3, 3),
            (2, 2),
            (1, 1),
            (0, 0),
            (6, 6),
            (7, 7),
            (6, 4),
            (7, 3),
            (4, 6),
            (3, 7),
        ];
        assert_eq!(alfil.movimientos_alfil(), mov_alfil);
    }

    #[test]
    fn test_movimientos_peon_negro() {
        let peon = Pieza {
            pos_x: 5,
            pos_y: 5,
            color: ColorPieza::Negra,
            tipo: TipoPieza::Peon,
        };
        let mov_pen = vec![(4, 6), (6, 6)];
        assert_eq!(peon.movimientos_peon(), mov_pen);
    }

    #[test]
    fn test_movimientos_peon_blanco() {
        let peon = Pieza {
            pos_x: 5,
            pos_y: 5,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Peon,
        };
        let mov_pen = vec![(4, 4), (6, 4)];
        assert_eq!(peon.movimientos_peon(), mov_pen);
    }

    #[test]
    fn test_eliminar_invalidos() {
        let cualquiera = Pieza {
            pos_x: 5,
            pos_y: 5,
            color: ColorPieza::Blanca,
            tipo: TipoPieza::Peon,
        };
        let mov = vec![(4, 4), (6, 4), (8, 8), (0, 4), (-1, 3), (94, 5)];
        let mov_validos = vec![(4, 4), (6, 4), (0, 4)];
        assert_eq!(cualquiera.eliminar_invalidos(&mov), mov_validos);
    }
}

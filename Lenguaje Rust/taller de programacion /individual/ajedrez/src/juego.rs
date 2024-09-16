use crate::pieza::*;
/// El juego manejara el resultado del mismo de acuerdo a las piezas que participan en el
pub struct Juego {
    /// La pieza de color blanco
    pub pieza_blanca: Pieza,
    /// La pieza de color negro
    pub pieza_negra: Pieza,
}

impl Juego {
    /// Devuelve un String con el resultado del juego
    ///
    /// recibe dos booleanos para determinar si las blancas y/o las negras fueron
    /// las que pueden comer a la otra y respecto a eso devuelven un resultado
    ///
    /// ej: let resultado = juego.imprimir_resultado(true, true);
    /// resultado == "E"
    fn imprimir_resultado(&self, blancas_comen: bool, negras_comen: bool) -> String {
        if blancas_comen && negras_comen {
            "E".to_string()
        } else if blancas_comen {
            "B".to_string()
        } else if negras_comen {
            "N".to_string()
        } else {
            "P".to_string()
        }
    }

    /// De acuerdo al estado del juego devuelve un String indicando el ganador del mismo
    ///
    /// Obtiene los movimientos tanto de la pieza blanca como de la negra y determina si
    /// de acuerdo a la posicion de su rival pueden comerse la una a la otra
    pub fn obtener_ganador(&self) -> String {
        let mov_blancas = self.pieza_blanca.obtener_movimientos();
        let mov_negras = self.pieza_negra.obtener_movimientos();
        let pos_blanca = (self.pieza_blanca.pos_x, self.pieza_blanca.pos_y);
        let pos_negra = (self.pieza_negra.pos_x, self.pieza_negra.pos_y);
        let mut blancas_comen = false;
        let mut negras_comen = false;
        if mov_blancas.contains(&pos_negra) {
            blancas_comen = true;
        }
        if mov_negras.contains(&pos_blanca) {
            negras_comen = true;
        }
        self.imprimir_resultado(blancas_comen, negras_comen)
    }
}

#[cfg(test)]
mod test_juego {
    use super::*;

    fn dar_juego() -> Juego {
        Juego {
            pieza_blanca: Pieza::new(0, 0, ColorPieza::Blanca, 't'),
            pieza_negra: Pieza::new(5, 5, ColorPieza::Negra, 'C'),
        }
    }

    #[test]
    fn test_imprimir_ganador_blancas() {
        let juego = dar_juego();
        assert_eq!(juego.imprimir_resultado(true, false), "B");
    }

    #[test]
    fn test_imprimir_ganador_negras() {
        let juego = dar_juego();
        assert_eq!(juego.imprimir_resultado(false, true), "N");
    }

    #[test]
    fn test_imprimir_ganador_ambos() {
        let juego = dar_juego();
        assert_eq!(juego.imprimir_resultado(true, true), "E");
    }

    #[test]
    fn test_imprimir_ganador_ninguno() {
        let juego = dar_juego();
        assert_eq!(juego.imprimir_resultado(false, false), "P");
    }
}

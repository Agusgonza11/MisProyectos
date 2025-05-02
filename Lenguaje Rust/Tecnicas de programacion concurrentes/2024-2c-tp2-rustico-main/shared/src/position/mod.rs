#[derive(Debug, Clone, PartialEq)]
pub struct Position {
    pub x: f64,
    pub y: f64,
}

impl Position {
    /// Calcula la posición a otro punto, que también debe ser de tipo Position
    pub fn distance_to(&self, point: &Self) -> f64 {
        let x = self.x - point.x;
        let y = self.y - point.y;

        let pot = x.powi(2) + y.powi(2);
        pot.sqrt()
    }

    pub fn move_to(&mut self, target: &Position, speed: f64) -> Position {
        if self == target {
            return target.to_owned();
        }
        let curr_x = self.y;
        let curr_y = self.x;

        let target_x = target.y;
        let target_y = target.x;
        let (magn_x, magn_y) = (target_y - curr_y, target_x - curr_x);
        let magnitude = (magn_x * magn_x + magn_y * magn_y).sqrt();
        let (unit_x, unit_y) = (magn_x / magnitude, magn_y / magnitude);

        let (mut new_x, mut new_y) = (curr_x + speed * unit_x, curr_y + speed * unit_y);

        if (curr_x < target_x && new_x > target_x) || (target_x < curr_x && target_x > new_x) {
            new_x = target_x
        }

        if (curr_y < target_y && new_y > target_y) || (target_y < curr_y && target_y > new_y) {
            new_y = target_y
        }
        Position { x: new_y, y: new_x }
    }
}

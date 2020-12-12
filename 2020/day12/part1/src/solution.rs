use regex::Regex;

struct Ship {
    direction: u32,
    ns_position: i32,
    ew_position: i32
}

impl Ship {
    fn new() -> Ship {
        Ship { direction: 0, ns_position: 0, ew_position: 0 }
    }

    fn turn_left(&mut self, degrees: u32) {
        self.direction = (self.direction + degrees) % 360;
    }

    fn turn_right(&mut self, degrees: u32) {
        self.direction = (self.direction + 360 - degrees) % 360;
    }

    fn move_forward(&mut self, distance: u32) {
        let direction = self.direction;
        self.move_direction(distance, direction);
    }

    fn move_direction(&mut self, distance: u32, direction: u32) {
        match direction {
            0 => self.ew_position += distance as i32,
            90 => self.ns_position += distance as i32,
            180 => self.ew_position -= distance as i32,
            270 => self.ns_position -= distance as i32,
            _ => panic!("Unknown direction!")
        };
    }
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let input_regex = Regex::new(r"^(?P<i>[A-Z]{1})(?P<v>\d+)$").unwrap();
    let mut ship = Ship::new();
    for line in args[0].lines() {
        if let Some(captures) = input_regex.captures(line) {
            let value = captures["v"].parse::<u32>().unwrap();
            match &captures["i"] {
                "E" => ship.move_direction(value, 0),
                "N" => ship.move_direction(value, 90),
                "W" => ship.move_direction(value, 180),
                "S" => ship.move_direction(value, 270),
                "F" => ship.move_forward(value),
                "L" => ship.turn_left(value),
                "R" => ship.turn_right(value),
                _ => panic!("Unknown instruction!")
            };
        }
    }
    Ok((ship.ns_position.abs() + ship.ew_position.abs()).to_string())
}

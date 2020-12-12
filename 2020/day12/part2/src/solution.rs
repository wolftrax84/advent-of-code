use regex::Regex;

struct Ship {
    ns_position: i32,
    ew_position: i32,
    waypoint_ns_position: i32,
    waypoint_ew_position: i32
}

impl Ship {
    fn new() -> Ship {
        Ship { ns_position: 0, ew_position: 0, waypoint_ns_position: 1, waypoint_ew_position: 10 }
    }

    fn turn_left(&mut self, degrees: u32) {        
        let w_ns_pos = self.waypoint_ns_position;
        let w_ew_pos = self.waypoint_ew_position;
        match degrees {
            90 => {
                self.waypoint_ns_position = w_ew_pos;
                self.waypoint_ew_position = w_ns_pos * -1;
            },
            180 => {
                self.waypoint_ns_position = w_ns_pos * -1;
                self.waypoint_ew_position = w_ew_pos * -1;
            },
            270 => {
                self.waypoint_ns_position = w_ew_pos * -1;
                self.waypoint_ew_position = w_ns_pos;
            },
            _ => panic!("Unknown turn value!")
        };
    }

    fn turn_right(&mut self, degrees: u32) {
        let w_ns_pos = self.waypoint_ns_position;
        let w_ew_pos = self.waypoint_ew_position;
        match degrees {
            90 => {
                self.waypoint_ns_position = w_ew_pos * -1;
                self.waypoint_ew_position = w_ns_pos;
            },
            180 => {
                self.waypoint_ns_position = w_ns_pos * -1;
                self.waypoint_ew_position = w_ew_pos * -1;
            },
            270 => {
                self.waypoint_ns_position = w_ew_pos;
                self.waypoint_ew_position = w_ns_pos * -1;
            },
            _ => panic!("Unknown turn value!")
        };
    }

    fn move_forward(&mut self, distance: u32) {
        self.ns_position = self.ns_position + (self.waypoint_ns_position * distance as i32);
        self.ew_position = self.ew_position + (self.waypoint_ew_position * distance as i32);
    }

    fn move_waypoint(&mut self, distance: u32, direction: u32) {
        match direction {
            0 => self.waypoint_ew_position += distance as i32,
            90 => self.waypoint_ns_position += distance as i32,
            180 => self.waypoint_ew_position -= distance as i32,
            270 => self.waypoint_ns_position -= distance as i32,
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
                "E" => ship.move_waypoint(value, 0),
                "N" => ship.move_waypoint(value, 90),
                "W" => ship.move_waypoint(value, 180),
                "S" => ship.move_waypoint(value, 270),
                "F" => ship.move_forward(value),
                "L" => ship.turn_left(value),
                "R" => ship.turn_right(value),
                _ => panic!("Unknown instruction!")
            };
        }
    }
    Ok((ship.ns_position.abs() + ship.ew_position.abs()).to_string())
}

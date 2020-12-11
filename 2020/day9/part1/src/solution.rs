use std::collections::VecDeque;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut previous_values: VecDeque<u64> = VecDeque::new();
    let mut values_to_check: Vec<u64> = Vec::new();
    for line in args[0].lines() {
        if previous_values.len() < 25 {
            previous_values.push_back(line.parse().unwrap());
        } else {
            values_to_check.push(line.parse().unwrap());
        }
    }

    for value in values_to_check.iter() {
        if !valid_value(&previous_values, *value) {
            return Ok(value.to_string());
        } else {
            previous_values.pop_front();
            previous_values.push_back(*value);
        }
    }

    Err("Not found!")
}

fn valid_value(previous_values: &VecDeque<u64>, value: u64) -> bool {
    for i in previous_values.iter() {
        for j in previous_values.iter() {
            if i + j == value {
                return true;
            }
        }
    }
    false
}
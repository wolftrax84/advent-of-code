use std::collections::VecDeque;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut previous_values: VecDeque<u64> = VecDeque::new();
    let mut values_to_check: Vec<u64> = Vec::new();
    let mut full_deque: VecDeque<u64> = VecDeque::new();
    for line in args[0].lines() {
        if previous_values.len() < 25 {
            previous_values.push_back(line.parse().unwrap());
        } else {
            values_to_check.push(line.parse().unwrap());
        }
        full_deque.push_back(line.parse().unwrap());
    }

    let mut key_value: u64 = 0;

    for value in values_to_check.iter() {
        if !valid_value(&previous_values, *value) {
            key_value = *value;
            break;
        } else {
            previous_values.pop_front();
            previous_values.push_back(*value);
        }
    }

    let mut sum_deque: VecDeque<u64> = VecDeque::new();
    let mut current_sum: u64 = 0;

    while current_sum != key_value {
        if current_sum < key_value {
            let next_val = full_deque.pop_front().unwrap();
            sum_deque.push_back(next_val);
            current_sum += next_val;
        } else {
            let last_val = sum_deque.pop_front().unwrap();
            current_sum -= last_val;
        }
    }

    sum_deque.make_contiguous().sort();

    Ok((sum_deque.pop_front().unwrap() + sum_deque.pop_back().unwrap()).to_string())
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
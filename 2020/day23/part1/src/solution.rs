use std::collections::VecDeque;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut cups: VecDeque<u8> = VecDeque::new();
    for arg in args {
        cups = arg.trim().chars().map(|c| c.to_string().parse::<u8>().unwrap()).collect::<VecDeque<u8>>();
    }

    for _i in 0..100 {
        let mut next_cups: VecDeque<u8> = VecDeque::new();
        next_cups.push_back(cups.pop_front().unwrap());
        let mut things = cups.split_off(3);
        let mut insert_key = next_cups[0];
        loop {
            insert_key = if insert_key == 1 { 9 } else { insert_key - 1 };
            if things.contains(&insert_key) {
                break;
            }
        }
        while things.len() > 0 {
            let next_thing = things.pop_front().unwrap();
            next_cups.push_back(next_thing);
            if next_thing == insert_key {
                next_cups.append(&mut cups);
            }
        }
        next_cups.rotate_left(1);
        cups = next_cups.clone();
    }
    while cups[0] != 1 {
        cups.rotate_left(1);
    }
    cups.pop_front();
    let mut result = String::new();
    while cups.len() > 0 {
        result.push_str(&cups.pop_front().unwrap().to_string())
    }
    Ok(result.to_string())
}

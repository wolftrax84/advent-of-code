use std::collections::HashMap;
use regex::Regex;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mem_regex = Regex::new(r"^mem\[(?P<loc>\d+)\] = (?P<val>\d+)").unwrap();
    let mut current_bitmask: (u64,u64) = (0,0);
    let mut memory: HashMap<u64, u64> = HashMap::new();
    for line in args[0].lines() {
        if let Some(_) = line.to_string().find("mask") {
            current_bitmask = set_bitmask(line.split(" = ").collect::<Vec<&str>>().get(1).unwrap());
        } else {
            if let Some(captures) = mem_regex.captures(line) {
                let mem_loc = captures["loc"].parse::<u64>().unwrap();
                let mem_val = run_bitmask(current_bitmask, &captures["val"]);
                memory.insert(mem_loc, mem_val);
            }
        }
    }

    Ok(memory.into_iter().fold(0, |acc, (_key, value)| acc + value).to_string())
}

fn set_bitmask(new_bitmask: &str) -> (u64,u64) {
    let mut bitmask = (u64::MAX,0);
    for (index, bit) in new_bitmask.chars().rev().enumerate() {
        match bit {
            '0' => bitmask.0 -= (2 as u64).pow(index as u32),
            '1' => bitmask.1 += (2 as u64).pow(index as u32),
            _ => ()
        };
    }
    bitmask
}

fn run_bitmask(bitmask: (u64,u64), value: &str) -> u64 {
    let mut new_value = value.parse::<u64>().unwrap();
    new_value = new_value & bitmask.0;
    new_value = new_value | bitmask.1;
    new_value
}

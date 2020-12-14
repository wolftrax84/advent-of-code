use std::collections::HashMap;
use regex::Regex;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mem_regex = Regex::new(r"^(?P<type>mem|mask)(\[(?P<loc>\d+)\])* = (?P<val>.+)").unwrap();
    let mut current_bitmask: Vec<String> = Vec::new();
    let mut memory: HashMap<u64, u64> = HashMap::new();

    for line in args[0].lines() {
        if let Some(captures) = mem_regex.captures(line) {
            match &captures["type"] {
                "mask" => {                     
                    current_bitmask = captures["val"].chars().map(|c| {c.to_string()}).collect::<Vec<String>>();
                },
                "mem" => {
                    assign_mem_locs(&mut captures["loc"].parse::<u64>().unwrap(), &current_bitmask, captures["val"].parse::<u64>().unwrap(), &mut memory);
                },
                _ => { panic!("Unrecognized instruction type!"); }
            }
        }
    }

    Ok(memory.into_iter().fold(0, |acc, (_key, value)| acc + value).to_string())
}

fn assign_mem_locs(base_mem_loc: &mut u64, bit_mask: &Vec<String>, value: u64, memory: &mut HashMap<u64, u64>) {
    let mut xs = Vec::new();
    let mut x_count = 0;
    for (index, bit) in bit_mask.into_iter().rev().enumerate() {
        if *bit == "1" {
            *base_mem_loc = *base_mem_loc | (2 as u64).pow(index as u32);
        } else if *bit == "X" {
            if *base_mem_loc & (2 as u64).pow(index as u32) != 0 {
                *base_mem_loc -= (2 as u64).pow(index as u32);
            }

            xs.push(index as u64);
            x_count += 1;
        }
    }

    for iteration in 0..(2 as u64).pow(x_count) {        
        let mut mem_loc = *base_mem_loc;
        for (index, x) in xs.clone().into_iter().enumerate() {
            if iteration & (2 as u64).pow(index as u32) != 0 {
                mem_loc += (2 as u64).pow(x as u32);
            }
        }
        memory.insert(mem_loc, value);
    }

}

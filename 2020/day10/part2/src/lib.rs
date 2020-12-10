use std::collections::HashMap;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut adapters: Vec<u32> = args[0].lines().map(|line| {line.parse::<u32>().unwrap()}).collect();
    adapters.sort();
    let mut current_joltage = 0;
    let mut joltage_diffs: (u16,u16,u16) = (0,0,1);
    
    for adapter in &adapters {
        match adapter - current_joltage {
            1 => { joltage_diffs.0 += 1; },
            2 => { joltage_diffs.1 += 1; },
            3 => { joltage_diffs.2 += 1; },
            _ => ()
        }
        current_joltage = *adapter;
    }

    let mut arrangements: u64 = 0;
    let mut sub_path_cache: HashMap<u32, u64> = HashMap::new();
    sub_path_cache.insert(adapters[adapters.len()-1], 1);

    for index in 0..3 {
        if adapters[index] <= 3 {
            arrangements += get_valid_paths(&adapters, index, &mut sub_path_cache);
        }
    }
    Ok((arrangements).to_string())
}

fn get_valid_paths(adapters: &Vec<u32>, index: usize, mut cache: &mut HashMap<u32,u64>) -> u64 {
    match cache.get(&adapters[index]) {
        Some(cached_value) => { return *cached_value; },
        None => { 
            let mut sub_paths_total = 0;
            for next_index in index+1..index+4 {
                if next_index < adapters.len() && adapters[next_index] - adapters[index] <= 3 {
                    sub_paths_total += get_valid_paths(&adapters, next_index, &mut cache);
                }
            }
            cache.insert(adapters[index], sub_paths_total);
            return sub_paths_total
        }
    }    
}
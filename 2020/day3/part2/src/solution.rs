const SLOPES: [(u32, u32); 5] = [(1,1),(3,1),(5,1),(7,1),(1,2)];

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut total_trees: u64 = 1;
    for (run, rise) in SLOPES.iter() {
        let trees = args[0]
            .trim()
            .lines()
            .enumerate()
            .filter_map(|(i,x)| {
                if i as u32 % rise != 0 {
                    return None
                }                
                let trimmed_str = x.trim();
                if String::from(trimmed_str).chars().collect::<Vec<char>>()[((i as u32)/rise * run) as usize%trimmed_str.len()] == '#' {
                    Some(String::from(x))
                } else {
                    None
                }
            })
            .collect::<Vec<String>>().len();
        total_trees *= trees as u64;
    }

    Ok(total_trees.to_string())
}

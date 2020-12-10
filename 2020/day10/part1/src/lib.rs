pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut adapters: Vec<u32> = args[0].lines().map(|line| {line.parse::<u32>().unwrap()}).collect();
    adapters.sort();
    
    let mut current_joltage = 0;
    let mut joltage_diffs: (u16,u16,u16) = (0,0,1);
    
    for adapter in adapters {
        match adapter - current_joltage {
            1 => { joltage_diffs.0 += 1; },
            2 => { joltage_diffs.1 += 1; },
            3 => { joltage_diffs.2 += 1; },
            _ => ()
        }
        current_joltage = adapter;
    }

    Ok((joltage_diffs.0 * joltage_diffs.2).to_string())
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    
    let mut arrival_time: u64 = 0;
    let mut buses: Vec<u64> = Vec::new();
    for (line_index, line) in args[0].lines().enumerate() {
        if line_index == 0 {
            arrival_time = line.parse::<u64>().unwrap();
        } else {
            for bus in line.split(",") {
                if let Ok(t) = bus.parse::<u64>() {
                    buses.push(t)
                }
            }
        }
    }
    
    let mut best_bus: (u64, u64) = (0, u64::MAX);

    for bus in buses {
        let  earliest_time = bus - (arrival_time % bus);
        if earliest_time < best_bus.1 {
            best_bus = ( bus, earliest_time );
        }
    }

    Ok((best_bus.0 * best_bus.1).to_string())
}

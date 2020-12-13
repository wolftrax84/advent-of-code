pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    
    let mut buses: Vec<(u64, u64)> = Vec::new();
    for (line_index, line) in args[0].lines().enumerate() {
        if line_index == 1 {
            for (bus_index, bus) in line.split(",").enumerate() {
                if let Ok(t) = bus.parse::<u64>() {
                    buses.push((t, bus_index as u64));
                }
            }
        }
    }

    let mut iteration: u64 = 0;
    let mut iter_interval: u64 = buses[0].0;
    for (i, (bus, _bus_index)) in buses[1..].iter().enumerate() {
        loop {
            let mut failed_iteration = false;
            for (bus2, bus_index2) in buses[0..i+2].iter() {
                if ( iteration + bus_index2 ) % bus2 != 0 {
                    failed_iteration = true;
                    break;
                }
            }
            if failed_iteration {
                iteration += iter_interval;
            } else {
                break;
            }
        }
        iter_interval = iter_interval * bus;
    }

    Ok(iteration.to_string())
}

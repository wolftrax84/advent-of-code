pub fn run(args: &Vec<String>) -> Result<String, &'static str> {

    let mut seats: Vec<u32> = 
        args[0].lines()
            .map(|line| -> u32 {
                let replaced_line = line.replace("F", "0").replace("B", "1").replace("L", "0").replace("R", "1");
                let row = u32::from_str_radix(&replaced_line[0..7],2).unwrap();
                let col = u32::from_str_radix(&replaced_line[7..],2).unwrap();
                row*8+col
            })
            .collect::<Vec<u32>>();

    seats.sort();
    
    match seats.pop() {
        Some(max) => Ok(max.to_string()),
        None => Err("No seats found")
    }
}

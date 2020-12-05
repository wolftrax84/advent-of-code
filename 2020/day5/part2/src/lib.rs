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

    for i in 1..seats.len()-1 {
        if seats[i] == seats[i-1]+2 {
            return Ok((seats[i]-1).to_string())
        }
    }

    Err("Seat not found")
}

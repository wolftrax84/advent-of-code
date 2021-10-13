const SUBJECT_NUMBER: u64 = 7;
const TRANSFORM_NUMBER: u64 = 20201227;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let input: Vec<u64> = args[0].lines().map(|line| {line.parse::<u64>().unwrap()}).collect();
    let (card_public_key, door_public_key) = (input[0], input[1]);
    
    let mut card_loop_size = 0;
    let mut card_val = 1;
    while card_val != card_public_key {
        if card_val != card_public_key {
            card_val *= SUBJECT_NUMBER;
            card_val %= TRANSFORM_NUMBER;
            card_loop_size += 1;
        }
    }

    let mut encryption_key = 1;
    for _i in 0..card_loop_size {
        encryption_key *= door_public_key;
        encryption_key %= TRANSFORM_NUMBER;
    }
    Ok(encryption_key.to_string())
}


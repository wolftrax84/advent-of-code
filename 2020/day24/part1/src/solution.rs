use std::collections::HashMap;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut flipped_tiles: HashMap<String, u16> = HashMap::new();
    for line in args[0].lines() {
        let mut pos: (f32, f32) = (0.0, 0.0);
        let mut line_iter = line.chars();
        loop {
            match line_iter.next() {
                Some(c) => {
                    match c {
                        'e' => (pos.0 += 1.0),
                        'w' => (pos.0 -= 1.0),
                        'n' | 's' => {
                            match line_iter.next() {
                                Some(c2) => {
                                    if c == 'n' { pos.1 += 0.5 } else { pos.1 -= 0.5 }
                                    match c2 {
                                        'e' => pos.0 += 0.5,
                                        'w' => pos.0 -= 0.5,
                                        _ => panic!("Unrecognized sub-direction: {}", c2)
                                    }
                                },
                                None => panic!("No cooresponding sub-direction!")
                            }
                        },
                        _ => panic!("Unrecognized direction {}", c)
                    }
                },
                None => break
            }
        }
        let count = flipped_tiles.entry(pos.0.to_string() + "|" + &pos.1.to_string()).or_insert(0);
        *count += 1;
    }
    let mut black_tiles = 0;
    for value in flipped_tiles.values() {
        if value % 2 != 0 {
            black_tiles += 1;
        }
    }
    Ok(black_tiles.to_string())
}

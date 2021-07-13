use std::collections::HashMap;

type Position = (f32, f32);
type Tiles = HashMap<String, Tile>;

#[derive(Clone)]
struct Tile {
    position: Position,
    neighbors: Vec<String>,
}

impl Tile {
    fn new(pos: &String) -> Tile {
        let pos_parts = pos.split('|').collect::<Vec<&str>>();
        let position = (pos_parts[0].parse::<f32>().unwrap(), pos_parts[1].parse::<f32>().unwrap());
        Tile {
            position: position,
            neighbors: get_tile_neighbors(position)
        }
    }
}

fn get_tile_neighbors(pos: Position) -> Vec<String> {
    vec![
        (pos.0 + 1.0).to_string() + "|" + &pos.1.to_string(), // E
        (pos.0 + 0.5).to_string() + "|" + &(pos.1 - 0.5).to_string(), // SE
        (pos.0 - 0.5).to_string() + "|" + &(pos.1 - 0.5).to_string(), // SW
        (pos.0 - 1.0).to_string() + "|" + &pos.1.to_string(), // W
        (pos.0 - 0.5).to_string() + "|" + &(pos.1 + 0.5).to_string(), // NW
        (pos.0 + 0.5).to_string() + "|" + &(pos.1 + 0.5).to_string(), // NE
    ]
}

fn get_tile_key(pos: Position) -> String {
    pos.0.to_string() + "|" + &pos.1.to_string()
}

fn check_tile(tile_key: &Tile, flipped: bool, flipped_tiles: &Vec<&String>) -> bool {
    let mut flipped_neighbors = 0;
    for n in &tile_key.neighbors {
        if flipped_tiles.contains(&&n) {
            flipped_neighbors += 1;
        }
    }
    if flipped {
        return flipped_neighbors == 1 || flipped_neighbors == 2;
    } else {
        return flipped_neighbors == 2;
    }
}

fn run_iteration(current_tiles: &Tiles) -> Tiles {
    let mut next_tiles: Tiles = HashMap::new();
    let mut check_queue: Vec<&String> = Vec::new();
    let tile_keys = current_tiles.keys().collect::<Vec<&String>>();
    let tiles = current_tiles.values();
    for key in &tile_keys {
        if !check_queue.contains(&key) {
            check_queue.push(key)
        }
    }
    for tile in tiles {
        for neighbor in tile.neighbors.iter() {
            if !check_queue.contains(&neighbor) {
                check_queue.push(neighbor);
            }
        }
    }
    for next_check in check_queue {
        let tile = Tile::new(next_check);
        let flip = check_tile(&tile, tile_keys.contains(&next_check), &tile_keys);
        if flip {
            next_tiles.insert(next_check.to_string(), tile);
        }
    }
    next_tiles
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut flipped_tiles: HashMap<String, Tile> = HashMap::new();
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
        let tile_key = get_tile_key(pos);
        let tile = Tile::new(&tile_key);
        if flipped_tiles.keys().collect::<Vec<&String>>().contains(&&tile_key) {
            flipped_tiles.remove(&tile_key);
        } else {
            flipped_tiles.insert(tile_key, tile);
        }
    }
    
    for _i in 1..101 {
        flipped_tiles = run_iteration(&flipped_tiles);
    }
    Ok(flipped_tiles.len().to_string())
}

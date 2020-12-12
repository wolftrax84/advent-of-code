#[derive(Clone)]
enum MapSpace {
    Floor,
    Empty,
    Occupied
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut seat_map: Vec<Vec<MapSpace>> = args[0].trim().lines()
        .map(|line| {
            line.trim().chars().map(|character| {
                match character {
                    'L' => MapSpace::Empty,
                    '#' => MapSpace::Occupied,
                    '.' => MapSpace::Floor,
                    _ => panic!("Unrecognized map space")
                }
            }).collect()
        }).collect();
      
    let map_width = seat_map[0].len();
    let map_height = seat_map.len();


    loop {
        let mut seat_state_changes = 0;
        let mut next_map = seat_map.clone();
        for row in 0..map_height {
            for col in 0..map_width {
                match seat_map[row][col] {
                    MapSpace::Floor => (),
                    MapSpace::Empty => {
                        if get_neighbor_count(row as i32, col as i32, &seat_map) == 0 {
                            next_map[row][col] = MapSpace::Occupied;
                            seat_state_changes += 1;
                        }
                    },
                    MapSpace::Occupied => {
                        if get_neighbor_count(row as i32, col as i32, &seat_map) >= 4 {
                            next_map[row][col] = MapSpace::Empty;
                            seat_state_changes += 1;
                        }
                    }
                }
            }
        }
        seat_map = next_map;
        if seat_state_changes == 0 {
            break;
        }
    }
    
    Ok(seat_map.concat().into_iter().filter(|space| { if let MapSpace::Occupied = space { true } else { false } }).collect::<Vec<MapSpace>>().len().to_string())
}

fn get_neighbor_count(row: i32, col: i32, seat_map: &Vec<Vec<MapSpace>>) -> u32 {
    let mut neighbors = 0;
    for n_row in row-1..row+2 {
        for n_col in col-1..col+2 {
            if n_row < 0 || n_row >= seat_map.len() as i32 || n_col < 0 || n_col >= seat_map[0].len() as i32 || (n_row == row && n_col == col) {
                continue;
            } else {
                if let MapSpace::Occupied = seat_map[n_row as usize][n_col as usize] {
                    neighbors += 1;
                }
            }
        }
    }
    neighbors
}

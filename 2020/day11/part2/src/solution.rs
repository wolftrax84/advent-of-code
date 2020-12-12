type NeighborList = Vec<(i32,i32)>;

#[derive(Clone)]
#[derive(PartialEq)]
enum MapSpace {
    Floor,
    Empty(Option<NeighborList>),
    Occupied(Option<NeighborList>)
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut seat_map: Vec<Vec<MapSpace>> = args[0].trim().lines()
        .map(|line| {
            line.trim().chars().map(|character| {
                match character {
                    'L' => {
                        MapSpace::Empty(None)
                    },
                    '#' => {
                        MapSpace::Occupied(None)
                    },
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
                match &seat_map[row][col] {
                    MapSpace::Floor => (),
                    MapSpace::Empty(o_neighbor_list) => {
                        let neighbor_list: Vec<(i32,i32)> = match o_neighbor_list {
                            Some(old_neighbor_list) => old_neighbor_list.clone(),
                            None => get_neighbor_list(row as i32, col as i32, &seat_map)
                        };
                        if get_neighbor_count(&neighbor_list, &seat_map) == 0 {
                            next_map[row][col] = MapSpace::Occupied(Some(neighbor_list));
                            seat_state_changes += 1;
                        }
                    },
                    MapSpace::Occupied(o_neighbor_list) => {
                        let neighbor_list = match o_neighbor_list {
                            Some(old_neighbor_list) => old_neighbor_list.clone(),
                            None => get_neighbor_list(row as i32, col as i32, &seat_map)
                        };
                        if get_neighbor_count(&neighbor_list, &seat_map) >= 5 {
                            next_map[row][col] = MapSpace::Empty(Some(neighbor_list));
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
    
    Ok(seat_map.concat().into_iter().filter(|space| { if let MapSpace::Occupied(_) = space { true } else { false } }).collect::<Vec<MapSpace>>().len().to_string())
}

fn get_neighbor_count(neighbor_list: &NeighborList, seat_map: &Vec<Vec<MapSpace>>) -> usize {
    let mut occupied_neighbors = 0;
    for neighbor in neighbor_list {
        if let MapSpace::Occupied(_) = seat_map[neighbor.0 as usize][neighbor.1 as usize] {
            occupied_neighbors += 1;
        }
    }
    occupied_neighbors
}

fn get_neighbor_list(row: i32, col: i32, seat_map: &Vec<Vec<MapSpace>>) -> NeighborList {
    let mut neighbor_list = Vec::new();
    let mut n_row = row;
    let mut n_col = col;
    //NW
    loop {
        n_row -= 1;
        n_col -= 1;
        if n_row < 0 || n_col < 0  {
            break;
        }
        if MapSpace::Floor != seat_map[n_row as usize][n_col as usize] {
            neighbor_list.push((n_row,n_col));
            break;
        }
    }

    //N
    n_row = row;
    loop {
        n_row -= 1;
        if n_row < 0  {
            break;
        }
        if MapSpace::Floor != seat_map[n_row as usize][col as usize] {
            neighbor_list.push((n_row, col));
            break;
        }
    }

    //NE
    n_row = row;
    n_col = col;
    loop {
        n_row -= 1;
        n_col += 1;
        if n_row < 0 || n_col >= seat_map[0].len() as i32  {
            break;
        }
        if MapSpace::Floor != seat_map[n_row as usize][n_col as usize] {
            neighbor_list.push((n_row,n_col));
            break;
        }
    }

    //W
    n_col = col;
    loop {
        n_col -= 1;
        if n_col < 0  {
            break;
        }
        if MapSpace::Floor != seat_map[row as usize][n_col as usize] {
            neighbor_list.push((row,n_col));
            break;
        }
    }

    //E
    n_col = col;
    loop {
        n_col += 1;
        if n_col >= seat_map[0].len() as i32  {
            break;
        }
        if MapSpace::Floor != seat_map[row as usize][n_col as usize] {
            neighbor_list.push((row,n_col));
            break;
        }
    }

    //SW
    n_row = row;
    n_col = col;
    loop {
        n_row += 1;
        n_col -= 1;
        if n_row >= seat_map.len() as i32 || n_col < 0 {
            break;
        }
        if MapSpace::Floor != seat_map[n_row as usize][n_col as usize] {
            neighbor_list.push((n_row,n_col));
            break;
        }
    }

    //S
    n_row = row;
    loop {
        n_row += 1;
        if n_row >= seat_map.len() as i32 {
            break;
        }
        if MapSpace::Floor != seat_map[n_row as usize][col as usize] {
            neighbor_list.push((n_row,col));
            break;
        }
    }
    
    //SE
    n_row = row;
    n_col = col;
    loop {
        n_row += 1;
        n_col += 1;
        if n_row >= seat_map.len() as i32 || n_col >= seat_map[0].len() as i32 {
            break;
        }
        if MapSpace::Floor != seat_map[n_row as usize][n_col as usize] {
            neighbor_list.push((n_row,n_col));
            break;
        }
    }

    neighbor_list
}
// use std::collections::HashMap;

// struct Puzzle {
//     grid: Vec<Vec<char>>,
//     tiles: HashMap<u64, Tile>,
//     borders: HashMap<usize, usize>
// }

// impl Puzzle {
//     fn new(tiles: Vec<Tile>) -> Puzzle {
//         let mut borders: HashMap<usize, usize> = HashMap::new();
//         let mut tile_map: HashMap<u64, Tile> = HashMap::new();
//         for tile in &tiles {
//             for border in tile.borders.iter() {
//                 *borders.entry(border.0).or_insert(0) += 1;
//                 *borders.entry(border.1).or_insert(0) += 1;
//             }            
//             tile_map.insert(tile.key, *tile);
//         }

//         let edge_length = (tiles.len() as f32).sqrt() as usize;
//         let tile_counts = (4, edge_length - 2, tiles.len() - (edge_length * 4 - 4));
//         dbg!(&tile_counts);

//         let mut edge_tiles: Vec<u64> = Vec::new();
//         let mut corner_tiles: Vec<u64> = Vec::new();
//         let mut inner_tiles: Vec<u64> = Vec::new();

//         for tile in &tiles {
//             let mut unique_border_count: usize = 0;
//             for (index, border) in tile.borders.iter().enumerate() {
//                 if let Some(1) = borders.get(&border.0) {
//                     tile_map.entry(tile.key).and_modify(|t| t.edge_locs += (2 as usize).pow(index as u32)); 
//                     unique_border_count += 1;
//                 }
//             }
//             match unique_border_count {
//                 1 => edge_tiles.push(tile.key),
//                 2 => corner_tiles.push(tile.key),
//                 _ => inner_tiles.push(tile.key)
//             }
//             println!("{} - {}", tile.key, tile_map.get(&tile.key).unwrap().edge_locs);
//         }
//         dbg!(&edge_tiles, &corner_tiles, &inner_tiles);
//         let num_edge_tiles_per_side = edge_tiles.len() / 4;

//         let first_corner_key = corner_tiles.pop().unwrap();
//         let first_corner = tile_map.get_mut(&first_corner_key).unwrap();

//         match first_corner.edge_locs {
//             3 => first_corner.rotate_left(), //NE
//             //5 => (), //NS
//             9 => (), //NW
//             6 => { first_corner.flip_vertical(); first_corner.flip_horizontal(); }, //ES
//             //10 => (), //EW
//             12 => first_corner.rotate_right(), //SW
//             _ => panic!("Shouldn't have this edge_locs value for corner!")
//         }

//         let found_tile_keys = vec![first_corner_key];

//         let mut grid: Vec<Vec<char>> = Vec::new();
//         // for i in 0..8 {
//         //     grid.push(first_corner.grid[i].to_vec());
//         // }

//         let mut grid_tiles: Vec<Vec<u64>> = Vec::new();



//         // Top Edge
//         let found_edge_tiles = 0;
//         while found_edge_tiles < num_edge_tiles_per_side {
//             for edge_tile_key in &edge_tiles {
//                 if let Some(edge_tile) = tile_map.get_mut(edge_tile_key) {
//                     for border in edge_tile.borders.into_iter() {
//                         if first_corner.borders[1].0 == border.0 {

//                         }
//                     }
//                 }
//             }
//         }

//         Puzzle {
//             grid,
//             tiles: tile_map,
//             borders
//         }
//     }
// }

// #[derive(Debug, Copy, Clone)]
// struct Tile {
//     key: u64,
//     puzzle_row: isize,
//     puzzle_col: isize,
//     borders: [(usize, usize); 4],
//     grid: [[char; 8]; 8],
//     edge_locs: usize,
// }

// impl Tile {
//     fn new(tile_str: &str) -> Tile {
//         let key = tile_str[5..9].parse().unwrap();
//         let mut top_border: usize = 0;
//         let mut top_border_rev: usize = 0;
//         let mut bottom_border: usize = 0;
//         let mut bottom_border_rev: usize = 0;
//         let mut left_border: Vec<String> = Vec::new();
//         let mut right_border: Vec<String> = Vec::new();
//         let mut borders: [(usize, usize); 4] = [(0,0); 4];
//         let mut grid = [['.'; 8]; 8];
//         for (i, row) in tile_str[11..].split("\n").enumerate() {
//             if i == 0 {
//                 let mut rev: Vec<String> = row.clone().chars().map(|c| c.to_string()).collect::<Vec<String>>();
//                 rev.reverse();
//                 top_border_rev = get_border_number(&rev.join(""));
//                 top_border = get_border_number(row);
//                 borders[0] = (top_border, top_border_rev);
//             }
//             if i == 9 {
//                 let mut rev: Vec<String> = row.clone().chars().map(|c| c.to_string()).collect::<Vec<String>>();
//                 rev.reverse();
//                 bottom_border_rev = get_border_number(&rev.join(""));
//                 bottom_border = get_border_number(row);
//                 borders[2] = (bottom_border, bottom_border_rev);
//             }
//             let mut row_chars = ['.'; 10];
//             for (j, character) in row.chars().enumerate() {
//                 row_chars[i] = character;
//                 if j == 0 {
//                     left_border.push(character.to_string().clone());
//                 } else if j == 9 {
//                     right_border.push(character.to_string().clone());                    
//                 } else {
//                     if i != 0 && i != 9 {
//                         grid[i-1][j-1] = character;
//                     }
//                 }
//             }
//         }
//         let mut left_border_rev = left_border.clone();
//         left_border_rev.reverse();
//         let left_border_rev = get_border_number(&left_border_rev.join(""));
//         let left_border = get_border_number(&left_border.join(""));
//         borders[3] = (left_border, left_border_rev);
//         let mut right_border_rev = right_border.clone();
//         right_border_rev.reverse();
//         let right_border_rev = get_border_number(&right_border_rev.join(""));
//         let right_border = get_border_number(&right_border.join(""));
//         borders[1] = (right_border, right_border_rev);
//         println!("{} - {}({}) | {}({}) | {}({}) | {}({})", key, top_border, top_border_rev, right_border, right_border_rev, bottom_border, bottom_border_rev, left_border, left_border_rev);
//         Tile {
//             key,
//             puzzle_col: -1,
//             puzzle_row: -1,
//             borders,
//             grid,
//             edge_locs: 0
//         }
//     }

//     fn flip_vertical(&mut self) {
//         self.grid.reverse();
//         let temp_top_border = self.borders[0];
//         self.borders[0] = self.borders[2];
//         self.borders[2] = temp_top_border;
//     }

//     fn flip_horizontal(&mut self) {
//         for i in 0..8 {
//             self.grid[i].reverse();
//         }
//         let temp_east_border = self.borders[1];
//         self.borders[1] = self.borders[3];
//         self.borders[3] = temp_east_border;
//     }

//     fn rotate_right(&mut self) {
//         let mut next_grid: [[char; 8]; 8] = [['.'; 8]; 8];
//         for i in 0..8 {
//             for j in 0..8 {
//                 next_grid[i][j] = self.grid[7-j][i];
//             }
//         }
//         let mut next_borders: [(usize, usize); 4] = [(0,0); 4];
//         for i in 0..4 {
//             next_borders[(i+3)%4] = self.borders[i];
//         }
//         self.grid = next_grid;
//         self.borders = next_borders;
//     }
    
//     fn rotate_left(&mut self) {
//         let mut next_grid: [[char; 8]; 8] = [['.'; 8]; 8];
//         for i in 0..8 {
//             for j in 0..8 {
//                 next_grid[i][j] = self.grid[j][7-i];
//             }
//         }
//         let mut next_borders: [(usize, usize); 4] = [(0,0); 4];
//         for i in 0..4 {
//             next_borders[(i+1)%4] = self.borders[i];
//         }
//         self.grid = next_grid;
//         self.borders = next_borders;

//     }
// }

// pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
//     dbg!(args[0].split("\n\n").collect::<Vec<&str>>().len());
//     let mut tiles: Vec<Tile> = Vec::new();
//     for (i, tile) in args[0].split("\n\n").enumerate() {
//         if tile.len() > 0 {
//             tiles.push(Tile::new(tile));
//         }
//     }
//     dbg!(&tiles[0].grid, &tiles[0].borders);
//     tiles[0].rotate_left();
//     dbg!(&tiles[0].grid, &tiles[0].borders);

//     let puzzle: Puzzle = Puzzle::new(tiles);

//     Err("Fail")
//     // Ok(puzzle.populate_grid().to_string())
// }

// fn get_border_number(border_str: &str) -> usize {
//     usize::from_str_radix(&border_str.chars().map(|character| if character == '.' { 0.to_string() } else {1.to_string() }).collect::<Vec<String>>().join(""), 2).unwrap()
// }

use std::collections::HashMap;

#[derive(Debug)]
enum TileType {
    Corner,
    Edge,
    Inner,
    Unknown,
}

#[derive(Copy, Clone, Debug)]
struct Loc {
    value: char,
    monster_part: bool,
}

impl Loc {
    fn new(value: char) -> Loc {
        Loc {
            value: value,
            monster_part: false
        }
    }
}

#[derive(Debug)]
struct Tile {
    id: u16,
    borders: [(u32,u32); 4],
    grid: [[Loc; 8]; 8],
    tile_type: TileType,
}

fn get_border_values(border_str: &str) -> (u32, u32) {
    let mut values: (u32, u32) = (0,0);
    for (i, val) in border_str.chars().enumerate() {
        if val == '#' {
            values.0 += 2u32.pow(9-i as u32);
            values.1 += 2u32.pow(i as u32);
        }
    }
    values
}

impl Tile {
    fn new(tile_input: &str) -> (u16, Tile) {
        let id: u16 = tile_input[5..9].parse().unwrap();
        let mut grid: [[Loc; 8]; 8] = [[Loc::new('.');8]; 8];
        let mut borders = [(0,0),(0,0),(0,0),(0,0)];
        for (i, row) in tile_input[11..].split("\n").enumerate() {
            for (j, val) in row.chars().enumerate() {
                if i > 0 && i < 9 && j > 0 && j < 9 {
                    grid[i-1][j-1].value = val;
                }
                if val == '#' {
                    if j == 0 { // Left Border
                        borders[3].0 += 2u32.pow(i as u32);
                        borders[3].1 += 2u32.pow(9-i as u32);
                    }
                    else if j == 9 { // Right Border
                        borders[1].0 += 2u32.pow(i as u32);
                        borders[1].1 += 2u32.pow(9-i as u32);
                    }
                }
            }
            if i == 0 { // Top Border
                borders[0] = get_border_values(row);
            }
            if i == 9 { // Bottom Border
                borders[2] = get_border_values(row);
            }
        }
        (id, Tile {
            id: id,
            borders: borders,
            tile_type: TileType::Unknown,
            grid: grid
        })
    }
}

#[derive(Debug)]
struct Puzzle {
    tiles: HashMap<u16, Tile>,
    picture: Vec<Vec<Loc>>
}

impl Puzzle {
    fn new(input: String) -> Puzzle {
        let mut tiles: HashMap<u16, Tile> = HashMap::new();
        for tile_input in input.split("\n\n") {
            if tile_input.len() > 0 {
                let new_tile = Tile::new(tile_input);
                tiles.insert(new_tile.0, new_tile.1);
            }
        }
        Puzzle {
            tiles: tiles,
            picture: Vec::new()
        }
    }
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let puzzle = Puzzle::new(args[0].to_string());
    for tile in puzzle.tiles.values() {
        println!("{} - {:?}", tile.id, tile.borders);
    }
    Err("Fail")
}

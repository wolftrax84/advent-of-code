use std::collections::HashMap;

struct Puzzle {
    tiles: Vec<Tile>,
    borders: HashMap<usize, usize>
}

impl Puzzle {
    fn new(tiles: Vec<Tile>) -> Puzzle {
        let mut borders: HashMap<usize, usize> = HashMap::new();
        for tile in &tiles {
            *borders.entry(tile.left_border).or_insert(0) += 1;
            *borders.entry(tile.right_border).or_insert(0) += 1;
            *borders.entry(tile.top_border).or_insert(0) += 1;
            *borders.entry(tile.bottom_border).or_insert(0) += 1;
            *borders.entry(tile.left_border_rev).or_insert(0) += 1;
            *borders.entry(tile.right_border_rev).or_insert(0) += 1;
            *borders.entry(tile.top_border_rev).or_insert(0) += 1;
            *borders.entry(tile.bottom_border_rev).or_insert(0) += 1;
        }
        Puzzle {
            tiles,
            borders
        }
    }

    fn populate_grid(&self) -> u64 {
        let mut left_borders: Vec<usize> = Vec::new();
        let mut right_borders: Vec<usize> = Vec::new();
        let mut top_borders: Vec<usize> = Vec::new();
        let mut bottom_borders: Vec<usize> = Vec::new();

        for tile in &self.tiles {
            if !left_borders.contains(&tile.left_border) {
                left_borders.push(tile.left_border);
            }
            if !right_borders.contains(&tile.right_border) {
                right_borders.push(tile.right_border);
            }
            if !top_borders.contains(&tile.top_border) {
                top_borders.push(tile.top_border);
            }
            if !bottom_borders.contains(&tile.bottom_border) {
                bottom_borders.push(tile.bottom_border);
            }
        }

        let mut result: u64 = 1;
        for tile in &self.tiles {
            if let Some(1) = &self.borders.get(&tile.top_border) {
                if let Some(1) = &self.borders.get(&tile.right_border) {
                    result *= tile.key;
                }
                if let Some(1) = &self.borders.get(&tile.left_border) {
                    result *= tile.key;
                }
            }
            if let Some(1) = &self.borders.get(&tile.bottom_border) {
                if let Some(1) = &self.borders.get(&tile.right_border) {
                    result *= tile.key;
                }
                if let Some(1) = &self.borders.get(&tile.left_border) {
                    result *= tile.key;
                }
            }
        }
        result
    }
}

#[derive(Copy, Clone)]
struct Tile {
    key: u64,
    left_border: usize,
    left_border_rev: usize,
    right_border: usize,
    right_border_rev: usize,
    top_border: usize,
    top_border_rev: usize,
    bottom_border: usize,
    bottom_border_rev: usize,
}

impl Tile {
    fn new(tile_str: &str) -> Tile {
        let key = tile_str[5..9].parse().unwrap();
        let mut top_border: usize = 0;
        let mut top_border_rev: usize = 0;
        let mut bottom_border: usize = 0;
        let mut bottom_border_rev: usize = 0;
        let mut left_border: Vec<String> = Vec::new();
        let mut right_border: Vec<String> = Vec::new();
        for (i, row) in tile_str[11..].split("\n").enumerate() {
            if i == 0 {
                let mut rev: Vec<String> = row.clone().chars().map(|c| c.to_string()).collect::<Vec<String>>();
                rev.reverse();
                top_border_rev = get_border_number(&rev.join(""));
                top_border = get_border_number(row);
            }
            if i == 9 {
                let mut rev: Vec<String> = row.clone().chars().map(|c| c.to_string()).collect::<Vec<String>>();
                rev.reverse();
                bottom_border_rev = get_border_number(&rev.join(""));
                bottom_border = get_border_number(row);
            }
            let mut row_chars = ['.'; 10];
            for (j, character) in row.chars().enumerate() {
                row_chars[i] = character;
                if j == 0 {
                    left_border.push(character.to_string().clone());
                }
                if j == 9 {
                    right_border.push(character.to_string().clone());                    
                }
            }
        }
        let mut left_border_rev = left_border.clone();
        left_border_rev.reverse();
        let left_border_rev = get_border_number(&left_border_rev.join(""));
        let left_border = get_border_number(&left_border.join(""));
        let mut right_border_rev = right_border.clone();
        right_border_rev.reverse();
        let right_border_rev = get_border_number(&right_border_rev.join(""));
        let right_border = get_border_number(&right_border.join(""));
        Tile {
            key,
            left_border,
            left_border_rev,
            right_border,
            right_border_rev,
            top_border,
            top_border_rev,
            bottom_border,
            bottom_border_rev,
        }
    }
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut tiles: Vec<Tile> = Vec::new();
    for tile in args[0].split("\n\n") {
        if tile.len() > 0 {
            tiles.push(Tile::new(tile));
        }
    }
    let puzzle: Puzzle = Puzzle::new(tiles);
    Ok(puzzle.populate_grid().to_string())
}

fn get_border_number(border_str: &str) -> usize {
    usize::from_str_radix(&border_str.chars().map(|character| if character == '.' { 0.to_string() } else {1.to_string() }).collect::<Vec<String>>().join(""), 2).unwrap()
}

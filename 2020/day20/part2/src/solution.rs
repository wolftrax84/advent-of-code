use std::collections::HashMap;

type Border = (u32,u32);
type BorderList = [Border;4];
type Grid = [[char;8];8];
type Picture = Vec<Vec<char>>;

fn get_border_values(border_str: &str) -> Border {
    let mut values = (0,0);
    for (i, val) in border_str.chars().enumerate() {
        if val == '#' {
            values.0 += 2u32.pow(9-i as u32);
            values.1 += 2u32.pow(i as u32);
        }
    }
    values
}

fn get_tile_data(input: &str) -> (u16, Grid, BorderList, u32) {
    let id: u16 = input[5..9].parse().unwrap();
    let mut grid: [[char; 8]; 8] = [['.';8]; 8];
    let mut borders = [(0,0),(0,0),(0,0),(0,0)];
    let mut hash_count = 0;
    for (i, row) in input[11..].split("\n").enumerate() {
        for (j, val) in row.chars().enumerate() {
            if i > 0 && i < 9 && j > 0 && j < 9 {
                grid[i-1][j-1] = val;
                if val == '#' {
                    hash_count += 1;
                }
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
    return (id, grid, borders, hash_count)
}

pub fn rotate_borders(borders: &BorderList) -> BorderList {
    [borders[3], borders[0], borders[1], borders[2]]
}

pub fn flip_borders_h(borders: &BorderList) -> BorderList {
    [borders[0], borders[3], borders[2], borders[1]]
}

pub fn flip_borders_v(borders: &BorderList) -> BorderList {
    [borders[2], borders[1], borders[0], borders[3]]
}

pub fn is_iso_edge(border_map: &HashMap<u32, u16>, border: &u32) -> bool {
    *border_map.get(border).unwrap() == 1
}

pub fn get_next_tile(
    group: &mut Vec<u16>, 
    borders: &HashMap<u16, BorderList>, 
    border_map: &HashMap<u32, u16>, 
    borders_to_match: &Vec<Option<u32>>,
    iso_edge: Option<usize>,
    tiles: &HashMap<u16, Grid>,
) -> (u16, BorderList, Grid) {
    let mut tile_key = 0;

    // Get the tile key and bordersthat corresponds to the match border from edges list
    let mut tile_borders = [(0,0),(0,0),(0,0),(0,0)];
    for temp_edge_key in group.iter() {
        let temp_edge_borders = *borders.get(temp_edge_key).unwrap();
        let temp_border_list = vec![temp_edge_borders[0].0, temp_edge_borders[0].1, temp_edge_borders[1].0, temp_edge_borders[1].1, temp_edge_borders[2].0, temp_edge_borders[2].1, temp_edge_borders[3].0, temp_edge_borders[3].1];
        let mut is_match = true;
        for border in borders_to_match {
            match border {
                Some(x) => if !temp_border_list.contains(x) {
                    is_match = false;
                },
                None => ()
            }            
        }
        if is_match {
            tile_key = *temp_edge_key;
            tile_borders = temp_edge_borders;
            break;
        }
    }
    let mut updated_tile = *tiles.get(&tile_key).unwrap();

    // Rotate until left side matches match edge
    for i in 0..8 {
        let mut left_match = false;
        match borders_to_match[0] {
            Some(x) => if tile_borders[3].0 == x || tile_borders[3].1 == x {
                left_match = true;
            },
            None => left_match = true
        }
        let mut up_match = false;
        match borders_to_match[1] {
            Some(x) => if tile_borders[0].0 == x || tile_borders[0].1 == x {
                up_match = true;
            },
            None => up_match = true
        }
        if left_match && up_match {
            break;
        }
        tile_borders = rotate_borders(&tile_borders);
        updated_tile = rotate_tile(updated_tile);
        if i == 3 {
            tile_borders = flip_borders_v(&tile_borders);
            updated_tile = flip_tile_v(updated_tile);
        }
    }

    // Check if top side is iso-edge, flip tile if necessary (flip rotation)
    match iso_edge {
        Some(e) => if !is_iso_edge(&border_map, &tile_borders[e].0) {
            match e {
                1 | 3 => {
                    tile_borders = flip_borders_h(&tile_borders);
                    updated_tile = flip_tile_h(updated_tile);
                },
                0 | 2 => {
                    tile_borders = flip_borders_v(&tile_borders);
                    updated_tile = flip_tile_v(updated_tile);
                },
                _ => panic!("iso_edge should be 0-3")
            }
        },
        None => ()
    }
    group.remove(group.iter().position(|v| *v == tile_key).unwrap());
    (tile_key, tile_borders, updated_tile)
}

fn rotate_tile(tile: Grid) -> Grid {
    let mut rotated_tile = tile;
    for x in 0..8 {
        for y in 0..8 {
            rotated_tile[y][7-x] = tile[x][y];
        }
    }
    rotated_tile
}

fn flip_tile_v(tile: Grid) -> Grid {
    let mut new_tile = tile;
    for i in 0..8 {
        new_tile[i] = tile[7-i];
    }
    new_tile
}

fn flip_tile_h(tile: Grid) -> Grid {
    let mut new_tile = tile;
    for i in 0..8 {
        for j in 0..8 {
            new_tile[i][j] = tile[i][7-j];
        }
    }
    new_tile
}

fn rotate_picture(picture: &Picture) -> Picture {
    let mut rotated_picture: Vec<Vec<char>> = Vec::new();
    for x in 0..picture.len() {
        rotated_picture.push(Vec::new());
        for y in 0..picture.len() {
            rotated_picture[x].push(picture[picture.len()-1-y][x]);
        }
    }
    rotated_picture
}

fn flip_picture(picture: &Picture) -> Picture {
    let mut new_picture = Vec::new();
    for i in 0..picture.len() {        
        new_picture.push(picture[picture.len()-1-i].clone());
    }
    new_picture
}

fn find_monsters(picture: &Picture) -> u16 {
    let mut monster_count = 0;
    for x in 1..picture.len()-1 {
        for y in 0..picture[0].len()-20 {
            match picture[x][y] {
                '.' => (),
                '#' => {
                    if picture[x+1][y+1] == '#' {
                        if picture[x+1][y+4] == '#' {
                            if picture[x][y+5] == '#' {
                                if picture[x][y+6] == '#' {
                                    if picture[x+1][y+7] == '#' {
                                        if picture[x+1][y+10] == '#' {
                                            if picture[x][y+11] == '#' {
                                                if picture[x][y+12] == '#' {
                                                    if picture[x+1][y+13] == '#' {
                                                        if picture[x+1][y+16] == '#' {
                                                            if picture[x][y+17] == '#' {
                                                                if picture[x-1][y+18] == '#' {
                                                                    if picture[x][y+18] == '#' {
                                                                        if picture[x][y+19] == '#' {
                                                                            monster_count += 1;
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                _ => panic!("shouldn't have a different char than . or #")
            }
        }
    }
    monster_count
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    // Parse input into puzzle pieces and map borders to pieces
    let mut tiles: HashMap<u16, Grid> = HashMap::new();
    let mut borders: HashMap<u16, BorderList> = HashMap::new();
    let mut border_map: HashMap<u32, u16> = HashMap::new();
    let mut hash_count = 0;
    for tile_input in args[0].split("\n\n") {
        if tile_input.len() > 0 {
            let (tile_key, tile_grid, tile_border_list, tile_hash_count) = get_tile_data(tile_input);
            tiles.insert(tile_key, tile_grid);
            borders.insert(tile_key, tile_border_list);
            hash_count += tile_hash_count;
            for border_pair in &tile_border_list {
                let entry = border_map.entry(border_pair.0).or_insert(0);
                *entry += 1;
                let entry = border_map.entry(border_pair.1).or_insert(0);
                *entry += 1;
            }
        }
    }

    // Separate borders into corners, edges, and middles   
    let mut corners: Vec<u16> = Vec::new();
    let mut edges: Vec<u16> = Vec::new();
    let mut middles: Vec<u16> = Vec::new();
    for (tile, border_list) in &borders {
        let mut iso_border_count = 0;
        for border in border_list {
            if *border_map.get(&border.0).unwrap() == 1 as u16 {
                iso_border_count += 1;
            }
        }
        match iso_border_count {
            0 => middles.push(*tile),
            1 => edges.push(*tile),
            2 => corners.push(*tile),
            _ => panic!("Tile should only have 0, 2, or 3 iso borders. {} had {}", tile, iso_border_count)
        }
    }

    let mut puzzle: Vec<Vec<(u16,Grid)>> = Vec::new();
    puzzle.push(Vec::new());
    
    let edge_count = edges.len()/4;

    // Take first corner in corners
    let start_corner_key = corners.remove(0);
    let mut start_corner_borders = *borders.get(&start_corner_key).unwrap();

    // Rotate until in top-left orientation (iso-edges on up and left sides)
    let mut updated_tile = *tiles.get(&start_corner_key).unwrap();
    for _i in 0..4 {
        if is_iso_edge(&border_map, &start_corner_borders[0].0) && is_iso_edge(&border_map, &start_corner_borders[3].0) {
            break;
        }
        start_corner_borders = rotate_borders(&start_corner_borders);
        updated_tile = rotate_tile(updated_tile);
    }

    // Add tile key and rotation to puzzle
    puzzle[0].push((start_corner_key,updated_tile));
    borders.insert(start_corner_key, start_corner_borders);

    // Set edge that needs to match (right side)
    let mut border_to_match = start_corner_borders[1].0;

    // For the number of edges on a side (number of edge tiles / 4)
    for _i in 0..edge_count {
        let (key, borders_list,new_tile) = get_next_tile(&mut edges,&borders,&border_map,&vec![Some(border_to_match),None],Some(0),&tiles);
        puzzle[0].push((key,new_tile));
        border_to_match = borders_list[1].0;
        borders.insert(key, borders_list);
    }

    // Top-right corner
    let (key, borders_list, new_tile) = get_next_tile(&mut corners,&borders,&border_map,&vec![Some(border_to_match),None],Some(0),&tiles);
    puzzle[0].push((key,new_tile));  
    borders.insert(key, borders_list);

    for i in 1..(edge_count+2) {
        puzzle.push(Vec::new());
        let mut left_match_border = None;
        for j in 0..(edge_count+2) {
            // Get upper match border
            let upper_tile_key = puzzle[i-1][j].0;
            let upper_match_border = Some((*borders.get(&upper_tile_key).unwrap())[2].0);
            let type_list;
            let iso_edge;
            match i {
                // Bottom Row
                x if x == edge_count+1 => {
                    match j {
                        // Bottom-Left corner
                        0 => {
                            type_list = &mut corners;
                            iso_edge = Some(3);
                        },
                        // Bottom-Right corner
                        y if y == edge_count+1 => {
                            type_list = &mut corners;
                            iso_edge = None;
                        },
                        // Middles
                        _ => {
                            type_list = &mut edges;
                            iso_edge = Some(2);
                        }
                    }
                },
                // Middle Rows
                _ => {
                    match j {
                        // Left edge
                        0 => {
                            type_list = &mut edges;
                            iso_edge = Some(3);
                        },
                        // Right edge
                        y if y == edge_count+1 => {
                            type_list = &mut edges;
                            iso_edge = Some(1);
                        },
                        // Middles
                        _ => {
                            type_list = &mut middles;
                            iso_edge = None;
                        }
                    }
                }
            }
            let (tile_key, tile_borders, tile_grid) = get_next_tile(type_list, &borders, &border_map, &vec![left_match_border, upper_match_border], iso_edge, &tiles);
            puzzle[i].push((tile_key, tile_grid));
            borders.insert(tile_key, tile_borders);
            left_match_border = Some(tile_borders[1].0);
        }
    }

    let mut big_picture: Vec<Vec<char>> = Vec::new();
    for _i in 0..puzzle.len()*8 {
        big_picture.push(Vec::new());
    }
    for i in 0..puzzle.len() {
        for j in 0..puzzle.len() {
            for x in 0..8 {
                for y in 0..8 {
                    big_picture[x+(i*8)].push(puzzle[i][j].1[x][y]);
                }
            }
        }
    }

    let mut num_monsters = 0;
    for i in 0..8 {
        num_monsters = find_monsters(&big_picture);
        if num_monsters > 0 {
            break;    
        }
        big_picture = rotate_picture(&big_picture);
        if i == 3 {
            big_picture = flip_picture(&big_picture);
        }
    }

    Ok((hash_count - (num_monsters*15) as u32).to_string())
}
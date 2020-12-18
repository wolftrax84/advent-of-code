#[derive(Clone)]
struct Grid {
    map: Vec<char>,
    xy_size: usize,
    z_size: usize,
    w_size: usize
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {

    let mut input: Vec<Vec<char>> = Vec::new();

    for line in args[0].lines() {
        input.push(line.chars().collect::<Vec<char>>())
    }

    let input_dimension = input.len();
    let layer_size = usize::pow(input_dimension + 14,2);

    let map_size = layer_size * 15;

    let mut grid: Grid = Grid {
        map: vec!['.'; map_size * 15],
        xy_size: input_dimension + 14,
        z_size: layer_size,
        w_size: map_size
    };

    for i in 0..input.len() {
        for j in 0..input[0].len() {
            let index = (grid.w_size * 7) + (grid.z_size * 7) + (grid.xy_size * (7+i)) + (7+j);
            grid.map[index] = input[i][j];
        }
    }

    // For number of cycles
    for i in 1..7 {
        let mut next_grid = grid.clone();
        // W Dimension
        for w in 7 - (i as isize)..7 + i as isize + 1 {
        // Z Dimension
            for z in 7 - (i as isize)..7 + i as isize + 1 {
                // Y Dimension
                for y in 7-i..7+input_dimension+i {
                    // X Dimension
                    for x in 7-i..7+input_dimension+i {
                        let index = (w as usize * grid.w_size) + (z as usize * layer_size) + (y * grid.xy_size) + x;
                        let mut neighbor_count = get_neighbor_count(index, &grid);
                        neighbor_count += get_neighbor_count(index-grid.w_size, &grid);
                        neighbor_count += get_neighbor_count(index+grid.w_size, &grid);
                        if grid.map[index] == '#' {
                            neighbor_count -= 1;
                        }
                        match grid.map[index] {
                            '#' => {
                                if neighbor_count != 2 && neighbor_count != 3 {
                                    next_grid.map[index] = '.';
                                }
                            },
                            '.' => {
                                if neighbor_count == 3 {
                                    next_grid.map[index] = '#';
                                }
                            },
                            _ => ()
                        }
                    }
                }
            } 
        }       
        grid = next_grid;
    }
    
    Ok(grid.map.into_iter().filter(|c| *c == '#').collect::<Vec<char>>().len().to_string())
}

fn get_neighbor_count(index: usize, grid: &Grid) -> u32 {
    let mut neighbor_count = 0;

    if grid.map[index - grid.z_size - grid.xy_size - 1] == '#' {
        neighbor_count += 1;
    } 
    if grid.map[index - grid.z_size - grid.xy_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.z_size - grid.xy_size + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.z_size-1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.z_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.z_size + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.z_size + grid.xy_size-1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.z_size + grid.xy_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.z_size + grid.xy_size + 1] == '#' {
        neighbor_count += 1;
    }

    if grid.map[index - grid.xy_size - 1] == '#' {
        neighbor_count += 1;
    } 
    if grid.map[index - grid.xy_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.xy_size + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.xy_size - 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.xy_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.xy_size + 1] == '#' {
        neighbor_count += 1;
    }

    if grid.map[index + grid.z_size - grid.xy_size - 1] == '#' {
        neighbor_count += 1;
    } 
    if grid.map[index + grid.z_size - grid.xy_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.z_size - grid.xy_size + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.z_size-1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.z_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.z_size + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.z_size + grid.xy_size-1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.z_size + grid.xy_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.z_size + grid.xy_size + 1] == '#' {
        neighbor_count += 1;
    }

    neighbor_count
}

#[derive(Clone)]
struct Grid {
    map: Vec<char>,
    dimension: usize,
    layer_size: usize
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {

    let mut input: Vec<Vec<char>> = Vec::new();

    for line in args[0].lines() {
        input.push(line.chars().collect::<Vec<char>>())
    }

    let input_dimension = input.len();
    let layer_size = usize::pow(input_dimension + 14,2);// * (input_dimension + 12);

    let map_size = layer_size * 15;

    let mut grid: Grid = Grid {
        map: vec!['.'; map_size],
        dimension: input_dimension + 14,
        layer_size
    };

    for i in 0..input.len() {
        for j in 0..input[0].len() {
            let index = (layer_size * 7) + (grid.dimension * (7+i)) + (7+j);
            grid.map[index] = input[i][j];
        }
    }

    // For number of cycles
    for i in 1..7 {
        let mut next_grid = grid.clone();
        // Z Dimension
        for z in 7 - (i as isize)..7 + i as isize + 1 {
            // Y Dimension
            for y in 7-i..7+input_dimension+i {
                // X Dimension
                for x in 7-i..7+input_dimension+i {
                    let index = (z as usize * layer_size) + (y * grid.dimension) + x;     
                    let neighbor_count = get_neighbor_count(index, &grid);
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
        grid = next_grid;
    }
    
    Ok(grid.map.into_iter().filter(|c| *c == '#').collect::<Vec<char>>().len().to_string())
}

fn get_neighbor_count(index: usize, grid: &Grid) -> u32 {
    let mut neighbor_count = 0;

    if grid.map[index - grid.layer_size - grid.dimension - 1] == '#' {
        neighbor_count += 1;
    } 
    if grid.map[index - grid.layer_size - grid.dimension] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.layer_size - grid.dimension + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.layer_size-1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.layer_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.layer_size + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.layer_size + grid.dimension-1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.layer_size + grid.dimension] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.layer_size + grid.dimension + 1] == '#' {
        neighbor_count += 1;
    }

    if grid.map[index - grid.dimension - 1] == '#' {
        neighbor_count += 1;
    } 
    if grid.map[index - grid.dimension] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - grid.dimension + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index - 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.dimension - 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.dimension] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.dimension + 1] == '#' {
        neighbor_count += 1;
    }

    if grid.map[index + grid.layer_size - grid.dimension - 1] == '#' {
        neighbor_count += 1;
    } 
    if grid.map[index + grid.layer_size - grid.dimension] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.layer_size - grid.dimension + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.layer_size-1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.layer_size] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.layer_size + 1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.layer_size + grid.dimension-1] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.layer_size + grid.dimension] == '#' {
        neighbor_count += 1;
    }
    if grid.map[index + grid.layer_size + grid.dimension + 1] == '#' {
        neighbor_count += 1;
    }

    neighbor_count
}
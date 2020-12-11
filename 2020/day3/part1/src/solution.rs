pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let trees = args[0]
        .trim()
        .lines()
        .enumerate()
        .filter_map(|(i,x)| {
            let trimmed_str = x.trim();
            if String::from(trimmed_str).chars().collect::<Vec<char>>()[(i*3 as usize)%trimmed_str.len()] == '#' {
                Some(String::from(x))
            } else {
                None
            }
        })
        .collect::<Vec<String>>().len();

    Ok(trees.to_string())
}

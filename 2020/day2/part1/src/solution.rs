#[derive(Debug)]
struct PasswordDef {
    key: char,
    lower_bound: u32,
    upper_bound: u32,
    password: String
}

impl PasswordDef {
    fn new() -> PasswordDef {
        PasswordDef {
            key: ' ',
            lower_bound: 0,
            upper_bound: 0,
            password: String::new()
        }
    }
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {

    let lines: Vec<PasswordDef> = parse_input(&args[0])?;

    let mut valid_passwords: u32 = 0;
    for line in lines {
        let mut chars: Vec<char> = line.password.chars().collect();
        chars.sort();
        let mut chars_iter = chars.iter();
        let start_index = chars_iter.position(|c| c == &line.key);
        match start_index {
            Some(_) => {
                let mut count: u32 = 1;
                let mut next_char = chars_iter.next();
                while next_char == Some(&line.key) {
                    count += 1;
                    next_char = chars_iter.next();
                }
                if count <= line.upper_bound && count >= line.lower_bound {
                    valid_passwords += 1;
                }
            },
            None => continue
        }
    }

    Ok(valid_passwords.to_string())
}

fn parse_input(args: &str) -> Result<Vec<PasswordDef>, &'static str> {
    args.trim()
    .lines()
    .map(|x| {
        let mut password_def = PasswordDef::new();
        let x_string = String::from(x);
        let mut space_split = x_string.trim().split_ascii_whitespace();
        match space_split.next() {
            Some(bounds) => {
                let mut bounds_split = bounds.trim().split_terminator('-');
                password_def.lower_bound = parse_bound(bounds_split.next())?;
                password_def.upper_bound = parse_bound(bounds_split.next())?;
            },
            None => return Err("Invalid Input: Failed parsing bounds")
        }
        if let Some(key_str) = space_split.next() {
            if let Some(key) = key_str.trim().chars().next() {
                password_def.key = key;
            } else {
                return Err("Invalid Input: Failed parsing key");
            }
        } else {
            return Err("Invalid Input: Failed parsing key");
        }
        if let Some(password_key) = space_split.next() {
            password_def.password = String::from(password_key.trim());
        } else {
            return Err("Invalid Input: Failed parsing password");
        }
        Ok(password_def)
    })
    .collect()
}

fn parse_bound(potential_bound: Option<&str>) -> Result<u32, &'static str> {
    let error = Err("Invalid Input: Failed parsing bound");
    if let Some(bound_str) = potential_bound {
        if let Ok(bound) = bound_str.parse::<u32>() {
            Ok(bound)
        } else {
            return error;
        }
    } else {
        return error;
    }
}

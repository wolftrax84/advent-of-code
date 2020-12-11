#[derive(Debug)]
struct PasswordDef {
    key: char,
    first_index: u32,
    second_index: u32,
    password: String
}

impl PasswordDef {
    fn new() -> PasswordDef {
        PasswordDef {
            key: ' ',
            first_index: 0,
            second_index: 0,
            password: String::new()
        }
    }
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {

    let lines: Vec<PasswordDef> = parse_input(&args[0])?;

    let mut valid_passwords: u32 = 0;
    for line in lines {
        let chars: Vec<char> = line.password.chars().collect();
        let first_match = chars.get((line.first_index-1) as usize);
        let second_match = chars.get((line.second_index-1) as usize);

        if (first_match == Some(&line.key) && second_match != Some(&line.key)) ||
            (first_match != Some(&line.key) && second_match == Some(&line.key)) {
                valid_passwords += 1;
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
            Some(indecies) => {
                let mut indecies_split = indecies.trim().split_terminator('-');
                password_def.first_index = parse_index(indecies_split.next())?;
                password_def.second_index = parse_index(indecies_split.next())?;
            },
            None => return Err("Invalid Input: Failed parsing indecies")
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

fn parse_index(potential_index: Option<&str>) -> Result<u32, &'static str> {
    let error = Err("Invalid Input: Failed parsing index");
    if let Some(index_str) = potential_index {
        if let Ok(index) = index_str.parse::<u32>() {
            Ok(index)
        } else {
            return error;
        }
    } else {
        return error;
    }
}

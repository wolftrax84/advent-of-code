use std::collections::HashMap;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut yes_answers = 0;
    for arg in args[0].split("\n\n") {
        let mut response_count = 0;
        let mut answers: HashMap<char, u32> = HashMap::new();
        for response in arg.trim().split('\n') {
            response_count += 1;
            for character in response.chars() {
                if character != '\n' {                    
                    match answers.get_mut(&character) {
                        Some(val) => *val += 1,
                        None => { answers.insert(character, 1); }
                    }                    
                }
            }
        }
        yes_answers += answers.values().filter(|v| *v == &response_count).collect::<Vec<&u32>>().len();
    }
    Ok(yes_answers.to_string())
}

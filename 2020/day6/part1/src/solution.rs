pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut yes_answers = 0;
    for arg in args[0].split("\n\n") {
        let mut chars = arg.chars().collect::<Vec<char>>();
        chars.sort();
        chars.dedup();
        yes_answers += if chars.contains(&'\n') {chars.len() - 1} else {chars.len()};
    }
    Ok(yes_answers.to_string())
}

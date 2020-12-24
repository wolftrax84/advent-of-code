use std::collections::HashMap;
use regex::Regex;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let atomic_rule_regex: Regex = Regex::new(r#"^"(?P<atom>a|b)"$"#).unwrap();

    let mut atomic_rules: Vec<(usize, String)> = Vec::new();
    let mut rule_map: HashMap<usize, String> = HashMap::new();

    let mut input_parts = args[0].split("\n\n");
    for line in input_parts.next().unwrap().lines() {
        if line == "" {
            break;
        }
        let mut rule_parts = line.split(":");
        let rule_id = rule_parts.next().unwrap().parse::<usize>().unwrap();
        let rule_def = rule_parts.next().unwrap().trim();

        if let Some(capture) = atomic_rule_regex.captures(rule_def) {
            atomic_rules.push((rule_id, capture["atom"].to_string()));
        } else {
            rule_map.insert(rule_id, rule_def.to_string());
        }
    }

    let mut regex_string = String::from(" ".to_string() + rule_map.get(&0).unwrap() + " ");

    loop {
        let mut done = true;
        for atomic_rule in &atomic_rules {
            regex_string = regex_string.replace(&atomic_rule.0.to_string(), &atomic_rule.1);
        }
        for character in regex_string.split_ascii_whitespace() {
            if let Ok(replaceable_char) = character.to_string().parse::<usize>() {
                done = false;
                if let Some(rule) = rule_map.get(&replaceable_char) {
                    let mut replacement_string = rule.clone();
                    if replacement_string.contains("|") {
                        replacement_string = String::from(" ( ".to_string() + &replacement_string + " ) ");
                    } else {
                        replacement_string = String::from(" ".to_string() + &replacement_string + " ");
                    }
                    regex_string = regex_string.replace(&String::from(" ".to_string() + &replaceable_char.to_string() + " "), &replacement_string);
                }
                break;
            }
        }
        if done {
            break;
        }
    }
    regex_string = String::from("^".to_string() + &regex_string + "$").replace(" ", "");

    let test_regex: Regex = Regex::new(&regex_string).unwrap();
    let mut count = 0;
    for line in args[0].lines() {
        if test_regex.is_match(line.trim()) == true {
            count += 1;
        }
    }

    Ok(count.to_string())
}

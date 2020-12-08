use regex::Regex;
use std::collections::HashMap;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let rule_outer_regex: Regex = Regex::new(r"^(?P<o>.+) bags contain.*$").unwrap();
    let rule_inner_regex: Regex = Regex::new(r"\d+ (?P<i>.+?) bag").unwrap();

    let mut bag_map: HashMap<String, Vec<String>> = HashMap::new();
    for line in args[0].lines() {
        if let Some(captures) = rule_outer_regex.captures(line) {
            let outer_bag = &captures["o"];

            for capture in rule_inner_regex.captures_iter(line) {
                let inner_bag = &capture["i"];
                match bag_map.get_mut(inner_bag) {
                    Some(map_val) => { map_val.push(String::from(outer_bag)) },
                    None => { bag_map.insert(String::from(inner_bag), vec![String::from(outer_bag)]); }
                }
            }
        }
    }

    let mut checked_bags: Vec<String> = vec![String::from("shiny gold")];
    match bag_map.get("shiny gold") {
        Some(shiny_gold_containers) => {
            let mut bags_to_check = shiny_gold_containers.clone();
            while bags_to_check.len() > 0 {
                let current_bag = bags_to_check.remove(0);
                checked_bags.push(current_bag.clone());
                if let Some(current_bag_containers) = bag_map.get(&current_bag) {
                    println!("{} -> {:?}", current_bag, current_bag_containers);
                    for container in current_bag_containers {
                        if !checked_bags.contains(container) && !bags_to_check.contains(container) {
                            bags_to_check.push(String::from(container));
                        }
                    }
                }
            }
        },
        None => return Ok(0.to_string())
    }

    // Subtract one from checked_bags to remove starting "shiny gold" ref
    Ok((checked_bags.len() - 1).to_string())
}


use regex::Regex;
use std::collections::HashMap;

#[derive(Debug)]
struct InnerBag {
    color: String,
    count: u32
}
impl InnerBag {
    fn new(color: String, count: u32) -> InnerBag {
        InnerBag { color, count }
    }
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let rule_outer_regex: Regex = Regex::new(r"^(?P<o>.+) bags contain.*$").unwrap();
    let rule_inner_regex: Regex = Regex::new(r"(?P<c>\d+) (?P<i>.+?) bag").unwrap();

    let mut bag_map: HashMap<String, Vec<InnerBag>> = HashMap::new();
    let mut solved_bags: HashMap<String, u32> = HashMap::new();
    for line in args[0].lines() {
        if let Some(captures) = rule_outer_regex.captures(line) {
            let outer_bag = &captures["o"];

            let mut inner_bags: Vec<InnerBag> = Vec::new();
            for capture in rule_inner_regex.captures_iter(line) {
                inner_bags.push(InnerBag::new(String::from(&capture["i"]), capture["c"].parse::<u32>().unwrap()));
            }

            if inner_bags.len() == 0 {
                solved_bags.insert(String::from(outer_bag), 0);
            }
            bag_map.insert(String::from(outer_bag), inner_bags);
        }
    }
    Ok(get_inner_bag_counts("shiny gold", &bag_map, &mut solved_bags).to_string())
}

fn get_inner_bag_counts(key: &str, bag_map: &HashMap<String, Vec<InnerBag>>, solved_bags: &mut HashMap<String, u32>) -> u32 {
    match solved_bags.get(key) {
        Some(bag_count) => *bag_count,
        None => {
            let mut inner_bags_total = 0;
            if let Some(inner_bags) = bag_map.get(key) {
                for inner_bag in inner_bags {
                    inner_bags_total += inner_bag.count * (get_inner_bag_counts(&inner_bag.color, bag_map, solved_bags) + 1);
                }
            }
            inner_bags_total
        }
    }
}
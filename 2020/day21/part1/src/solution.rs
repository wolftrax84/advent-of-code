use regex::Regex;
use std::collections::HashMap;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let input_regex = Regex::new(r"(?P<i>.+) \(contains (?P<a>.+)\)").unwrap();
    let mut allergy_counts: HashMap<String, u32> = HashMap::new();
    let mut ingredient_counts: HashMap<String, u32> = HashMap:: new();
    let mut ingredient_map: HashMap<String, HashMap<String, u32>> = HashMap::new();
    for line in args[0].lines() {
        if let Some(captures) = input_regex.captures(line) {
            let mut ingredients: Vec<String> = vec![];
            let ingredient_matches = &captures["i"].split(' ').collect::<Vec<&str>>();
            for ingredient in ingredient_matches {
                ingredients.push(String::from(*ingredient))
            }
            let mut allergies: Vec<String> = vec![];
            let allergy_matches = &captures["a"].split(',').map(|a| {a.trim()}).collect::<Vec<&str>>();
            for allergy in allergy_matches {
                allergies.push(String::from(*allergy))
            }
            for allergy in &allergies {
                let counter = allergy_counts.entry(allergy.to_string()).or_insert(0);
                *counter += 1;
            }
            for ingredient in ingredients {
                let counter = ingredient_counts.entry(ingredient.to_string()).or_insert(0);
                *counter += 1;
                let i = ingredient_map.entry(ingredient.to_string()).or_insert(HashMap::new());
                for allergy in &allergies {
                    let counter = i.entry(allergy.to_string()).or_insert(0);
                    *counter += 1;
                }
            }
        }
    }
    let mut result = 0;
    for ingredient in ingredient_map.keys() {
        let mut bad = false;
        for allergy in ingredient_map[ingredient].keys() {
            if ingredient_map[ingredient][allergy] == allergy_counts[allergy] {
                bad = true;
            }
        }
        if !bad {
            result += ingredient_counts[ingredient];
        }
    }
    Ok(result.to_string())
}

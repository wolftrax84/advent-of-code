use regex::Regex;
use std::collections::HashMap;

struct Food {
    ingredients: Vec<String>,
    allergies: Vec<String>,
}

#[derive(PartialEq)]
enum LogicValue {
    Null,
    No,
    Yes,
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let input_regex = Regex::new(r"(?P<i>.+) \(contains (?P<a>.+)\)").unwrap();
    let mut allergy_counts: HashMap<String, u32> = HashMap::new();
    let mut ingredient_map: HashMap<String, HashMap<String, u32>> = HashMap::new();
    let mut food_list: Vec<Food> = Vec::new();
    let mut line_counter: usize = 0;
    let mut ingredients_list: Vec<String> = Vec::new();
    let mut allergies_list: Vec<String> = Vec::new();
    for line in args[0].lines() {
        if let Some(captures) = input_regex.captures(line) {
            food_list.push(Food {ingredients: Vec::new(), allergies: Vec::new() });
            let mut ingredients: Vec<String> = vec![];
            let ingredient_matches = &captures["i"].split(' ').collect::<Vec<&str>>();
            for ingredient in ingredient_matches {
                ingredients.push(String::from(*ingredient));
                if !ingredients_list.contains(&ingredient.to_string()) {
                    ingredients_list.push(ingredient.to_string());
                }
            }
            let mut allergies: Vec<String> = vec![];
            let allergy_matches = &captures["a"].split(',').map(|a| {a.trim()}).collect::<Vec<&str>>();
            for allergy in allergy_matches {
                allergies.push(String::from(*allergy));
                if !allergies_list.contains(&allergy.to_string()) {
                    allergies_list.push(allergy.to_string());
                }
            }
            for allergy in &allergies {
                food_list[line_counter].allergies.push(allergy.to_string());
                let counter = allergy_counts.entry(allergy.to_string()).or_insert(0);
                *counter += 1;
            }
            for ingredient in ingredients {
                food_list[line_counter].ingredients.push(ingredient.to_string());
                let i = ingredient_map.entry(ingredient.to_string()).or_insert(HashMap::new());
                for allergy in &allergies {
                    let counter = i.entry(allergy.to_string()).or_insert(0);
                    *counter += 1;
                }
            }
        }
        line_counter += 1;
    }

    let mut clean_ingredients: Vec<String> = Vec::new();
    for ingredient in ingredient_map.keys() {
        let mut bad = false;
        for allergy in ingredient_map[ingredient].keys() {
            if ingredient_map[ingredient][allergy] == allergy_counts[allergy] {
                bad = true;
            }
        }
        if !bad {
            clean_ingredients.push(String::from(ingredient.to_string()));
        }
    }

    for ingredient in &clean_ingredients {
        ingredient_map.remove_entry(ingredient);
    }

    ingredients_list.retain(|i| {!clean_ingredients.contains(i)});

    let mut dirty_food_list: Vec<Food> = Vec::new();

    line_counter = 0;
    for food in &food_list {
        dirty_food_list.push(Food {ingredients: Vec::new(), allergies: Vec::new() });
        for ingredient in &food.ingredients {
            if !&clean_ingredients.contains(&ingredient) {
                dirty_food_list[line_counter].ingredients.push(ingredient.to_string())
            }
        }
        for allergy in &food.allergies {
            dirty_food_list[line_counter].allergies.push(allergy.to_string())
        }
        line_counter += 1;
    }
    let mut logic_ingredients: HashMap<String, HashMap<String, LogicValue>> = HashMap::new();
    let mut logic_allergies: HashMap<String, HashMap<String, LogicValue>> = HashMap::new();

    for ingredient in &ingredients_list {
        let r = logic_ingredients.entry(ingredient.to_string()).or_insert(HashMap::new());
        for allergy in &allergies_list {
            r.entry(allergy.to_string()).or_insert(LogicValue::Null);
        }
    }

    for allergy in &allergies_list {
        let r = logic_allergies.entry(allergy.to_string()).or_insert(HashMap::new());
        for ingredient in &ingredients_list {
            r.entry(ingredient.to_string()).or_insert(LogicValue::Null);
        }
    }

    let mut found_pairs: Vec<(String, String)> = Vec::new();

    for food in &dirty_food_list {
        if food.allergies.len() == food.ingredients.len() {
            for ingredient in &ingredients_list {
                let l_i = logic_ingredients.entry(ingredient.to_string()).or_default();
                for allergy in &allergies_list {
                    if food.ingredients.contains(&ingredient) != food.allergies.contains(&allergy) {
                        let l_a = l_i.entry(allergy.to_string()).or_insert(LogicValue::Null);
                        match l_a {
                            LogicValue::Yes => (),
                            _ => *l_a = LogicValue::No
                        }
                    }
                }
            }
            for allergy in &allergies_list {
                let l_a = logic_allergies.entry(allergy.to_string()).or_default();
                for ingredient in &ingredients_list {
                    if food.ingredients.contains(&ingredient) != food.allergies.contains(&allergy) {
                        let l_i = l_a.entry(ingredient.to_string()).or_insert(LogicValue::Null);
                        match l_i {
                            LogicValue::Yes => (),
                            _ => *l_i = LogicValue::No
                        }
                    }
                }
            }
        } else {
            for allergy in &allergies_list {
                if food.allergies.contains(allergy) {
                    let l_a = logic_allergies.entry(allergy.to_string()).or_default();
                    for ingredient in &ingredients_list {
                        if !food.ingredients.contains(&ingredient) {
                            let l_i = l_a.entry(ingredient.to_string()).or_insert(LogicValue::Null);
                            match l_i {
                                LogicValue::Yes => (),
                                _ => *l_i = LogicValue::No
                            }
                        }
                    }
                }
            }
        }
    }

    while found_pairs.len() < allergies_list.len() {
        for ingredient in &ingredients_list {
            let l_i = logic_ingredients.entry(ingredient.to_string()).or_default();
            let l_i_null: Vec<&LogicValue> = l_i.values().filter(|v| {**v == LogicValue::Null}).collect();
            if l_i_null.len() == 1 {
                let mut found_pair: (String, String) = (String::new(),String::new());
                for allergy in &allergies_list {
                    let l_a = l_i.entry(allergy.to_string()).or_insert(LogicValue::Null);
                    if *l_a == LogicValue::Null {
                        found_pairs.push((ingredient.to_string(),allergy.to_string()));
                        found_pair = (ingredient.to_string(), allergy.to_string());
                        break;
                    }
                }
                for ingredient_x in &ingredients_list {
                    for allergy_x in &allergies_list {
                        let i_box = logic_ingredients.get_mut(ingredient_x).unwrap().get_mut(allergy_x).unwrap();
                        let a_box = logic_allergies.get_mut(allergy_x).unwrap().get_mut(ingredient_x).unwrap();
                        if ingredient_x == &found_pair.0 || allergy_x == &found_pair.1 {
                            if ingredient_x == &found_pair.0 && allergy_x == &found_pair.1 {
                                *i_box = LogicValue::Yes;
                                *a_box = LogicValue::Yes;
                            } else {
                                *i_box = LogicValue::No;
                                *a_box = LogicValue::No;
                            }
                        }
                    }
                }
                break;
            }
        }

        for allergy in &allergies_list {
            let l_a = logic_allergies.entry(allergy.to_string()).or_default();
            let l_a_null: Vec<&LogicValue> = l_a.values().filter(|v| {**v == LogicValue::Null}).collect();
            if l_a_null.len() == 1 {                
                let mut found_pair: (String, String) = (String::new(),String::new());
                for ingredient in &ingredients_list {
                    let l_i = l_a.entry(ingredient.to_string()).or_insert(LogicValue::Null);
                    if *l_i == LogicValue::Null {
                        found_pairs.push((ingredient.to_string(),allergy.to_string()));
                        found_pair = (ingredient.to_string(), allergy.to_string());
                        break;
                    }
                }
                for ingredient_x in &ingredients_list {
                    for allergy_x in &allergies_list {
                        let i_box = logic_ingredients.get_mut(ingredient_x).unwrap().get_mut(allergy_x).unwrap();
                        let a_box = logic_allergies.get_mut(allergy_x).unwrap().get_mut(ingredient_x).unwrap();
                        if ingredient_x == &found_pair.0 || allergy_x == &found_pair.1 {
                            if ingredient_x == &found_pair.0 && allergy_x == &found_pair.1 {
                                *i_box = LogicValue::Yes;
                                *a_box = LogicValue::Yes;
                            } else {
                                *i_box = LogicValue::No;
                                *a_box = LogicValue::No;
                            }
                        }
                    }
                }
                break;
            }
        }
    }

    found_pairs.sort_by_key(|p| p.1.to_string());
    let result = found_pairs.iter().map(|p| p.0.to_string()).collect::<Vec<String>>().join(",");
    Ok(result)
}

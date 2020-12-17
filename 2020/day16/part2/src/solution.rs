use regex::Regex;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let rule_regex: Regex = Regex::new(r"^(?P<name>.+): (?P<r1>\d+-\d+) or (?P<r2>\d+-\d+).*$").unwrap();

    let mut my_ticket: Vec<u32> = Vec::new();
    let mut nearby_tickets: Vec<Vec<u32>> = Vec::new();
    let mut ticket_rules: Vec<(String, Vec<u32>, u32)> = Vec::new();

    let mut input_part = 1;
    for line in args[0].lines() {
        if line == "\n".to_string() {
            continue;
        } else if line.trim() == "your ticket:" {
            input_part = 2;
        } else if line.trim() == "nearby tickets:" {
            input_part = 3;
        } else {
            match input_part {
                1 => {
                    if let Some(captures) = rule_regex.captures(line) {
                        let mut rule: Vec<u32> = Vec::new();
                        let rule_part1 = captures["r1"].split("-").map(|v| v.parse::<u32>().unwrap()).collect::<Vec<u32>>();
                        for i in rule_part1[0]..rule_part1[1]+1 {
                            rule.push(i);
                        }
                        let rule_part2 = captures["r2"].split("-").map(|v| v.parse::<u32>().unwrap()).collect::<Vec<u32>>();
                        for i in rule_part2[0]..rule_part2[1]+1 {
                            rule.push(i);
                        }
                        ticket_rules.push((captures["name"].to_string(), rule, u32::MAX));
                    }
                },
                2 => {
                    my_ticket = line.trim().split(",").map(|v| v.parse::<u32>().unwrap()).collect::<Vec<u32>>();
                    input_part = 0;
                },
                3 => nearby_tickets.push(line.trim().split(",").map(|v| v.parse::<u32>().unwrap()).collect::<Vec<u32>>()),
                _ => ()
            }
        }
    }

    let mut valid_tickets = Vec::new();
    for ticket in &nearby_tickets {
        let mut invalid_ticket = false;
        for value in ticket {
            let mut error = true;
            for rule in &ticket_rules {
                if rule.1.contains(&value) {
                    error = false;
                    break;
                }
            }
            if error == true {
                invalid_ticket = true;
                break;
            }
        }
        if invalid_ticket == false {
            valid_tickets.push(ticket.clone());
        }
    }

    let mut found_indicies: Vec<u32> = Vec::new();

    loop {
        for i in 0..my_ticket.len() {
            let mut possible_indicies: Vec<u32> = (0..ticket_rules.len() as u32).filter(|x| !found_indicies.contains(x)).collect::<Vec<u32>>();
            for ticket in &valid_tickets {
                if let Some(val) = ticket.get(i) {
                    for (rule_index, rule) in ticket_rules.iter().enumerate() {
                        if found_indicies.contains(&(rule_index as u32)) == true {
                            continue;
                        }
                        if !rule.1.contains(val) {
                            possible_indicies.remove(possible_indicies.iter().position(|x| *x == rule_index as u32).unwrap());
                        }
                    }
                }
            }
            if possible_indicies.len() == 1 {
                if let Some(rule) = ticket_rules.get_mut(possible_indicies[0] as usize) {
                    rule.2 = i as u32;
                }
                found_indicies.push(possible_indicies[0] as u32);
            }
        }
        if found_indicies.len() == ticket_rules.len() {
            break;
        }
    }

    let mut departure_values: u64 = 1;
    for rule in ticket_rules {
        if rule.0.contains("departure") {
            if let Some(val) = my_ticket.get(rule.2 as usize) {
                departure_values *= *val as u64;
            }
        }
    }

    Ok(departure_values.to_string())
}

use regex::Regex;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let rule_regex: Regex = Regex::new(r"^(?P<name>.+): (?P<r1>\d+-\d+) or (?P<r2>\d+-\d+).*$").unwrap();

    let mut nearby_tickets: Vec<Vec<u32>> = Vec::new();
    let mut ticket_rules: Vec<(String, Vec<u32>)> = Vec::new();

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
                        ticket_rules.push((captures["name"].to_string(), rule));
                    }
                },
                2 => (),
                3 => {
                    nearby_tickets.push(line.trim().split(",").map(|v| v.parse::<u32>().unwrap()).collect::<Vec<u32>>());
                },
                _ => ()
            }
        }
    }

    let mut scan_error_rate = 0;
    for ticket in nearby_tickets {
        for value in ticket {
            let mut error = true;
            for rule in &ticket_rules {
                if rule.1.contains(&value) {
                    // println!("{} - {:?}",&value, &rule);
                    error = false;
                    break;
                }
            }
            if error == true {
                // println!("{}",&value);
                scan_error_rate += value;
            }
        }
    }

    Ok(scan_error_rate.to_string())
}

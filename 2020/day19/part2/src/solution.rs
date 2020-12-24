use std::collections::HashMap;

enum Rule {
    Atom(char),
    Branch(Vec<usize>, Vec<usize>),
    Sequence(Vec<usize>)
}

struct StringMatcher {
    rules: HashMap<usize, Rule>,
}

impl StringMatcher {
    fn new(rules: HashMap<usize, Rule>) -> StringMatcher {
        StringMatcher { rules }
    }

    fn match_string(&self, string_to_match: &str, mut rules_to_check: &mut Vec<usize>) -> bool {
        if string_to_match.is_empty() && rules_to_check.is_empty() {
            return true;
        }
        if string_to_match.is_empty() || rules_to_check.is_empty() {
            return false;
        }
        let next_rule = &self.rules[&rules_to_check.pop().unwrap()];
        match next_rule {
            Rule::Atom(atom) => self.match_atom(string_to_match, *atom, &mut rules_to_check),
            Rule::Sequence(seq) => self.match_sequence(string_to_match, &seq, &mut rules_to_check),
            Rule::Branch(seq1, seq2) => {
                self.match_sequence(string_to_match, &seq1, &mut rules_to_check.clone()) ||
                self.match_sequence(string_to_match, &seq2, &mut rules_to_check.clone())
            }
        }
    }

    fn match_atom(&self, string_to_match: &str, atom: char, mut rules_to_check: &mut Vec<usize>) -> bool {
        match string_to_match.chars().next() {
            Some(next_atom) if next_atom == atom => self.match_string(&string_to_match[1..], &mut rules_to_check),
            _ => false
        }
    }

    fn match_sequence(&self, string_to_match: &str, sequence: &Vec<usize>, rules_to_check: &mut Vec<usize>) -> bool {
        sequence.iter().rev().for_each(|next_rule| rules_to_check.push(*next_rule));
        self.match_string(string_to_match, rules_to_check)
    }
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let atomic_rule_regex: regex::Regex = regex::Regex::new(r#"^"(?P<atom>a|b)"$"#).unwrap();
    let mut rule_map: HashMap<usize, Rule> = HashMap::new();

    let mut input_parts = args[0].split("\n\n");
    for line in input_parts.next().unwrap().lines() {
        if line == "" {
            break;
        }
        let mut rule_parts = line.split(":");
        let rule_id = rule_parts.next().unwrap().parse::<usize>().unwrap();
        let rule_def = rule_parts.next().unwrap().trim();

        if let Some(capture) = atomic_rule_regex.captures(rule_def) {
            rule_map.insert(rule_id, Rule::Atom(capture["atom"].chars().next().unwrap()));
        } else {
            if rule_def.contains("|") == true {
                let mut branches: Vec<Vec<usize>> = Vec::new();
                for branch in rule_def.split("|") {
                    branches.push(branch.split_ascii_whitespace().map(|rule_str| rule_str.parse::<usize>().unwrap()).collect());
                }
                rule_map.insert(rule_id, Rule::Branch(branches[0].clone(), branches[1].clone()));
            } else {
                rule_map.insert(rule_id, Rule::Sequence(rule_def.split_ascii_whitespace().map(|rule_str| rule_str.parse::<usize>().unwrap()).collect()));
            }
        }
    }

    let matcher = StringMatcher::new(rule_map);
    let count = input_parts.next().unwrap().lines().filter(|string_to_match| matcher.match_string(string_to_match, &mut vec![0])).collect::<Vec<&str>>().len();

    Ok(count.to_string())
}

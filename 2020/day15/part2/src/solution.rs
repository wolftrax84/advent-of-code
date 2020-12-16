use std::collections::HashMap;

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut history: HashMap<u32,(u32, bool)> = HashMap::new();
    let mut current_val = (0,0);
    for line in args[0].lines() {
        for (index, num) in line.split(",").enumerate() {
            current_val = (num.parse::<u32>().unwrap(), index as u32);
            history.insert(current_val.0, (index as u32 + 1, false));
        }
    }
    for i in (current_val.1 + 1)..30000000 {
        let mut next_val = 0;
        let mut new_val = true;
        if let Some(last_seen) = history.get_mut(&current_val.0) {
            if last_seen.0 != i {
                next_val = i - last_seen.0;
            }
            new_val = false;
        }
        history.insert(current_val.0, (i as u32, new_val));
        current_val = (next_val, i);
    }
    Ok(current_val.0.to_string())
}

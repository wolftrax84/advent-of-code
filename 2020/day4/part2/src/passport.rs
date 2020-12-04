use regex::Regex;

const EYE_COLORS: [&str; 7] = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"];

pub struct Passport {
    byr: bool,
    iyr: bool,
    eyr: bool,
    hgt: bool,
    hcl: bool,
    ecl: bool,
    pid: bool
}

impl Passport {
    pub fn new() -> Passport {
        Passport {
            byr: false,
            iyr: false,
            eyr: false,
            hgt: false,
            hcl: false,
            ecl: false,
            pid: false
        }
    }

    pub fn is_valid(&self) -> bool {
        return self.byr && self.iyr && self.eyr && self.hgt && self.hcl && self.ecl && self.pid;
    }

    pub fn update_value(&mut self, value: &str) {
        let hair_color_regex: Regex = Regex::new(r"^#[0-9a-f]{6}$").unwrap();
        let height_regex: Regex = Regex::new(r"^(?P<v>\d+)(?P<u>cm|in)$").unwrap();
        let key_vals: Vec<&str> = value.split_terminator(':').collect();

        match key_vals[0] {
            "byr" => self.byr = match key_vals[1].parse::<u32>() {
                                    Ok(val) => val >= 1920 && val <= 2002, 
                                    Err(_) => false
            },
            "iyr" => self.iyr = match key_vals[1].parse::<u32>() {
                                    Ok(val) => val >= 2010 && val <= 2020,
                                    Err(_) => false
            },
            "eyr" => self.eyr = match key_vals[1].parse::<u32>() {
                                    Ok(val) => val >= 2020 && val <= 2030, 
                                    Err(_) => false
            },
            "hgt" => self.hgt = {
                if !height_regex.is_match(key_vals[1]) {
                    false
                } else {
                    let re = height_regex.captures(key_vals[1]).unwrap();
                    match &re["u"] {
                        "in" => if let Ok(height) = &re["v"].parse::<u32>() {
                                    *height >= 59 && *height <= 76        
                                } else {
                                    false
                                },
                        "cm" => if let Ok(height) = &re["v"].parse::<u32>() {
                                    *height >= 150 && *height <= 193        
                                } else {
                                    false
                                }
                        _ => false
                    }
                }
            },
            "hcl" => self.hcl = hair_color_regex.is_match(key_vals[1]),
            "ecl" => self.ecl = EYE_COLORS.contains(&key_vals[1]),
            "pid" => self.pid = key_vals[1].chars().collect::<Vec<char>>().len() == 9,
            "cid" => (),
            _ => panic!("Invalid passport field: {}", value)
        }
    }
}

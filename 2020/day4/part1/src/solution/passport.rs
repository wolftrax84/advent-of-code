pub struct Passport {
    byr: Option<String>,
    iyr: Option<String>,
    eyr: Option<String>,
    hgt: Option<String>,
    hcl: Option<String>,
    ecl: Option<String>,
    pid: Option<String>,
    cid: Option<String>,
}

impl Passport {
    pub fn new() -> Passport {
        Passport {
            byr: None,
            iyr: None,
            eyr: None,
            hgt: None,
            hcl: None,
            ecl: None,
            pid: None,
            cid: None
        }
    }

    pub fn is_valid(&self) -> bool {
        if let None = self.byr {
            false
        } else if let None = self.iyr {
            false
        } else if let None = self.eyr {
            false
        } else if let None = self.hgt {
            false
        } else if let None = self.hcl {
            false
        } else if let None = self.ecl {
            false
        } else if let None = self.pid {
            false
        } else {
            true
        }
    }

    pub fn update_value(&mut self, value: &str) {
        let key_vals: Vec<&str> = value.split_terminator(':').collect();

        match key_vals[0] {
            "byr" => self.byr = Some(String::from(key_vals[1])),
            "iyr" => self.iyr = Some(String::from(key_vals[1])),
            "eyr" => self.eyr = Some(String::from(key_vals[1])),
            "hgt" => self.hgt = Some(String::from(key_vals[1])),
            "hcl" => self.hcl = Some(String::from(key_vals[1])),
            "ecl" => self.ecl = Some(String::from(key_vals[1])),
            "pid" => self.pid = Some(String::from(key_vals[1])),
            "cid" => self.cid = Some(String::from(key_vals[1])),
            _ => panic!("Invalid passport field: {}", value)
        }
    }
}

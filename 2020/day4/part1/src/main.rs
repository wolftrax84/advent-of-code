use advent_of_code_2020_day4_part1::run;
use std::{ fs, process };
use std::io::ErrorKind;

fn main() {
    /////////////////////////////////////////////////////////////
    //    Tests
    /////////////////////////////////////////////////////////////
    let tests: Vec<Test> = vec![
        Test {
            expected: 2.to_string(), inputs: vec![String::from("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
            byr:1937 iyr:2017 cid:147 hgt:183cm
            
            iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
            hcl:#cfa07d byr:1929
            
            hcl:#ae17e1 iyr:2013
            eyr:2024
            ecl:brn pid:760753108 byr:1931
            hgt:179cm
            
            hcl:#cfa07d eyr:2025 pid:166559648
            iyr:2011 ecl:brn hgt:59in
            ")]
        }
    ];

    for test in tests {
        if test.run_test() == false {
            process::exit(1);
        }
    }

    /////////////////////////////////////////////////////////////
    //    Actual Puzzle
    /////////////////////////////////////////////////////////////
    let puzzle_input = get_puzzle_input();

    println!("{:?}", run(&vec![puzzle_input]).unwrap_or_else(|error| {
        String::from("Error: ") + error
    }));
}

struct Test {
    expected: String,
    inputs: Vec<String>,
}

impl Test {
    fn run_test(&self) -> bool {
        match run(&self.inputs) {
            Ok(result) => {
                if result == self.expected {
                    true
                } else {
                    println!("Test Failed: expected={} | got={}", self.expected, result);
                    false
                }
            },
            Err(error) => {
                println!("Test Failed: error: {}", error);
                false
            }
        }
    }
}

fn get_puzzle_input() -> String{
    fs::read_to_string("input.txt").unwrap_or_else(|error| {
        if error.kind() == ErrorKind::NotFound {
            fs::read_to_string("../input.txt").unwrap_or_else(|error2| {
                panic!("Problem reading puzzle input from day file: {}", error2);
            })
        } else {
            panic!("Problem reading puzzle input from part file: {}", error);
        }
    })    
}


use advent_of_code_2020_day1_part1::run;
use std::{ fs, process };
use std::io::ErrorKind;

fn main() {
    /////////////////////////////////////////////////////////////
    //    Tests
    /////////////////////////////////////////////////////////////
    let tests: Vec<Test> = vec![
        Test { expected: String::from("514579"), inputs: vec![String::from("1721
        979
        366
        299
        675
        1456
        ")]}
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


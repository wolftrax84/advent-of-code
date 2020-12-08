use advent_of_code_2020_day7_part1::run;
use std::{ fs, process };
use std::io::ErrorKind;

fn main() {
    /////////////////////////////////////////////////////////////
    //    Tests
    /////////////////////////////////////////////////////////////
    let tests: Vec<Test> = vec![
        Test {
            expected: 4.to_string(),
            inputs: vec![String::from("light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
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


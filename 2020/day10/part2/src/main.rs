use advent_of_code_2020_day10_part2::run;
use std::{ fs, process };
use std::io::ErrorKind;
use std::time::{ Instant, Duration };

fn main() {
    /////////////////////////////////////////////////////////////
    //    Tests
    /////////////////////////////////////////////////////////////
    let tests: Vec<Test> = vec![
        Test {
            expected: 8.to_string(),
            inputs: vec![String::from("16
10
15
5
1
11
7
19
6
12
4
")]
        },
        Test {
            expected: 19208.to_string(),
            inputs: vec![String::from("28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
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

    let now = Instant::now();
    println!("Puzzle completed ({})- {:?}", format_timer(now.elapsed()), run(&vec![puzzle_input]).unwrap_or_else(|error| {
        String::from("Error: ") + error
    }));
}

struct Test {
    expected: String,
    inputs: Vec<String>,
}

impl Test {
    fn run_test(&self) -> bool {
        let now = Instant::now();
        match run(&self.inputs) {
            Ok(result) => {
                if result == self.expected {
                    println!("Test Passed ({})- expected: {} | got: {}", format_timer(now.elapsed()), self.expected, result);
                    true
                } else {
                    println!("Test Failed - expected={} | got={}", self.expected, result);
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

fn format_timer(duration: Duration) -> String {
    if duration.as_micros() < 1000 {
        duration.as_micros().to_string() + "us"
    } else if duration.as_millis() < 1000 {
        duration.as_millis().to_string() + "ms"
    } else {
        duration.as_secs().to_string() + "s"
    }
}

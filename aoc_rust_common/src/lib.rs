use std::{ fs, process, time };
use std::io::ErrorKind;

pub type AocSolution = dyn Fn(&Vec<String>) -> Result<String, &'static str>;

pub struct Test {
    pub expected: String,
    pub inputs: Vec<String>
}

impl Test {
    pub fn run_test(&self, solution: &AocSolution) -> bool {
        let run_result = run(solution, &self.inputs);
        match run_result.result {
            Ok(result) => {
                let passed = self.expected == result;
                println!("Test {} ({}) - expected: {} | got: {}", 
                    match passed { true => "Passed", false => "Failed" }, 
                    format_timer(run_result.execution_time),
                    self.expected,
                    result    
                );
                passed
            },
            Err(error) => panic!("Test Failed - error: {}", error)
        }
    }
}

pub fn run_solution(solution: &AocSolution, tests: Vec<Test>) {

    // Run tests, exit on a failure    
    for test in tests {
        if test.run_test(solution) == false {
            process::exit(1);
        }
    }

    // Get actual puzzle input and run it
    let actual_input = get_puzzle_input();

    let actual_result = run(solution, &vec![actual_input]);
    match actual_result.result {
        Ok(result) => println!("Actual ({}) - {}", format_timer(actual_result.execution_time), result),
        Err(error) => panic!("Actual Failed - error: {}", error)
    }
}

pub fn get_puzzle_input() -> String{
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

///////////////////////////////////////////////////////////
/// Private functions
///////////////////////////////////////////////////////////

struct RunResult {
    result: Result<String, &'static str>,
    execution_time: time::Duration
}

fn run(solution: &AocSolution, inputs: &Vec<String>) -> RunResult {
    let timer = time::Instant::now();
    let result = solution(inputs);
    let execution_time = timer.elapsed();
    RunResult { result, execution_time }
}

fn format_timer(duration: time::Duration) -> String {
    if duration.as_micros() < 1000 {
        duration.as_micros().to_string() + "us"
    } else if duration.as_millis() < 1000 {
        duration.as_millis().to_string() + "ms"
    } else {
        duration.as_secs().to_string() + "s"
    }
}

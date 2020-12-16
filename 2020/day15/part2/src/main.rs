use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test { expected: 175594.to_string(), inputs: vec!["0,3,6\n".to_string()] }
    ];

    run_solution(&solution::run, tests);    
}

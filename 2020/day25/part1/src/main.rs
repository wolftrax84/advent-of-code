use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: "14897079".to_string(),
            inputs: vec!["5764801
17807724".to_string()]
        }
    ];

    run_solution(&solution::run, tests);    
}

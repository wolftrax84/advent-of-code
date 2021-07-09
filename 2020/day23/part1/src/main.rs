use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: "67384529".to_string(),
            inputs: vec!["389125467\n".to_string()]
        }
    ];

    run_solution(&solution::run, tests);    
}

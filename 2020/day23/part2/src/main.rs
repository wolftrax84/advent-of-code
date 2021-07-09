use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: "149245887792".to_string(),
            inputs: vec!["389125467\n".to_string()]
        }
    ];

    run_solution(&solution::run, tests);    
}

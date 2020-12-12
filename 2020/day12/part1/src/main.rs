use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: 25.to_string(),
            inputs: vec!["F10\nN3\nF7\nR90\nF11\n".to_string()]
        }
    ];

    run_solution(&solution::run, tests);    
}

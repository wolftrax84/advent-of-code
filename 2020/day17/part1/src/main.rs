use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: 112.to_string(),
            inputs: vec![
".#.
..#
###
".to_string()
            ]
        }
    ];

    run_solution(&solution::run, tests);    
}

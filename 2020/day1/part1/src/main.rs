use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test { expected: String::from("514579"), inputs: vec![String::from("1721
        979
        366
        299
        675
        1456
        ")]}
    ];

    run_solution(&solution::run, tests);    
}

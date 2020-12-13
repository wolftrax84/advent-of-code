use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test { expected: 295.to_string(), inputs: vec![String::from("939\n7,13,x,x,59,x,31,19\n")]}
    ];

    run_solution(&solution::run, tests);    
}

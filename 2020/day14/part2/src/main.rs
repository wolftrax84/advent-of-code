use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test { expected: 208.to_string(), inputs: vec![String::from("mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
")]}
    ];

    run_solution(&solution::run, tests);    
}

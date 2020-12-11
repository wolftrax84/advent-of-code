use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: 6.to_string(),
            inputs: vec![String::from("abc

a
b
c

ab
ac

a
a
a
a

b
")]
        }
    ];

    run_solution(&solution::run, tests);    
}

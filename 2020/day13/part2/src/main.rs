use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test { expected: 3417.to_string(), inputs: vec![String::from("zzz\n17,x,13,19\n")] },
        Test { expected: 1068781.to_string(), inputs: vec![String::from("939\n7,13,x,x,59,x,31,19\n")] }
    ];

    run_solution(&solution::run, tests);    
}

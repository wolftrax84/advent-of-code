use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test { expected: 1.to_string(), inputs: vec![String::from("1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
")]
        }];

    run_solution(&solution::run, tests);    
}

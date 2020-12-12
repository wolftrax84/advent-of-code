use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: 26.to_string(),
            inputs: vec![String::from("L.LL.LL.LL
            LLLLLLL.LL
            L.L.L..L..
            LLLL.LL.LL
            L.LL.LL.LL
            L.LLLLL.LL
            ..L.L.....
            LLLLLLLLLL
            L.LLLLLL.L
            L.LLLLL.LL
            ")]
        }
    ];

    run_solution(&solution::run, tests);    
}

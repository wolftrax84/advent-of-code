use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test{
            expected: 291.to_string(),
            inputs: vec!["Player 1:\r\n9\r\n2\r\n6\r\n3\r\n1\r\n\r\nPlayer 2:\r\n5\r\n8\r\n4\r\n7\r\n10\r\n".to_string()]
        }
    ];

    run_solution(&solution::run, tests);    
}

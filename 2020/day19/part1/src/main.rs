use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: 2.to_string(),
            inputs: vec![r#"0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
"#.to_string()]
        }
    ];

    run_solution(&solution::run, tests);    
}

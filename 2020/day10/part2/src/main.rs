use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        Test {
            expected: 8.to_string(),
            inputs: vec![String::from("16
10
15
5
1
11
7
19
6
12
4
")]
        },
        Test {
            expected: 19208.to_string(),
            inputs: vec![String::from("28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
")]
        }
    ];

    run_solution(&solution::run, tests);    
}

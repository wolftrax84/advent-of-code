pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut total: u64 = 0;
    for equation in args[0].lines() {
        let equation_chars = equation.chars().filter(|c| *c != ' ');
        let mut lhs: Vec<u64> = Vec::new();
        let mut stack: Vec<Operation> = Vec::new();
        let mut op: OpType = OpType::Sum;
        for character in equation_chars {
            match character {
                '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' => {
                    let parsed_val = character.to_string().parse::<u64>().unwrap();
                    match lhs.len() {
                        0 => lhs.push(parsed_val),//lhs = Some(vec![parsed_val]),
                        _ => {
                            match op {
                                OpType::Sum => {
                                    let popped_val = lhs.pop().unwrap();
                                    lhs.push(popped_val + parsed_val);
                                },
                                OpType::Multiply => lhs.push(parsed_val)
                            }
                        }
                    }
                },
                '+' => op = OpType::Sum,
                '*' => op = OpType::Multiply,
                '(' => { 
                    stack.push(Operation {lhs, op: op.clone() });
                    lhs = Vec::new();
                },
                ')' => if let Some(mut popped_op) = stack.pop() {
                    let mut paren_result = 1;
                    for paren_val in &lhs {
                        paren_result *= paren_val;
                    }   
                    match lhs.len() {
                        0 => lhs.push(paren_result),
                        _ => lhs = resolve(&mut popped_op, paren_result)
                    }
                },
                any => panic!("Unrecognized equation character: {}", any)
            }
        }
        let mut eq_result = 1;
        for val in &lhs {
            eq_result *= val;
        }
        total += eq_result;
    }
    Ok(total.to_string())
}

fn resolve(operation: &mut Operation, val: u64) -> Vec<u64> {
    match operation.op {
        OpType::Sum => {
            if let Some(popped_val) = operation.lhs.pop() {
                operation.lhs.push(popped_val + val);
            } else {
                return vec![val];
            }
        },
        OpType::Multiply => operation.lhs.push(val)
    }
    operation.lhs.clone()
}

struct Operation {
    lhs: Vec<u64>,
    op: OpType
}

#[derive(Clone, Debug)]
enum OpType {
    Sum,
    Multiply
}

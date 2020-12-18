pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut total: u64 = 0;
    for equation in args[0].lines() {
        let equation_chars = equation.chars().filter(|c| *c != ' ');
        let mut lhs: Option<u64> = None;
        let mut stack: Vec<Operation> = Vec::new();
        let mut op: OpType = OpType::Sum;
        for character in equation_chars {
            match character {
                '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' => {
                    let parsed_val = character.to_string().parse::<u64>().unwrap();
                    match lhs {
                        Some(l) => lhs = match op {
                            OpType::Sum => Some(l + parsed_val),
                            OpType::Multiply => Some(l * parsed_val)
                        },
                        None => lhs = Some(parsed_val)
                    }
                },
                '+' => op = OpType::Sum,
                '*' => op = OpType::Multiply,
                '(' => { 
                    stack.push(Operation {lhs, op: op.clone() });
                    lhs = None;
                },
                ')' => if let Some(popped_op) = stack.pop() {
                    lhs = Some(resolve(popped_op, lhs.unwrap()));
                },
                any => panic!("Unrecognized equation character: {}", any)
            }
        }
        total += lhs.unwrap();
    }
    Ok(total.to_string())
}

fn resolve(operation: Operation, val: u64) -> u64 {
    if let Some(l) = operation.lhs {   
        match operation.op {
            OpType::Sum => l + val,
            OpType::Multiply => l * val,
        }
    } else {
        val
    }
}

#[derive(Clone)]
struct Operation {
    lhs: Option<u64>,
    op: OpType
}

#[derive(Clone)]
enum OpType {
    Sum,
    Multiply
}

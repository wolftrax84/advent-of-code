#[derive(Debug)]
enum Instruction {
    Acc(InstructionMetadata),
    Jmp(InstructionMetadata),
    Nop(InstructionMetadata)
}

impl Instruction {
    fn executed(&self) -> bool {
        match &self {
            Instruction::Acc(i) | Instruction::Jmp(i) | Instruction::Nop(i) => i.executed
        }
    }

    fn execute(&mut self, ptr: &mut u32, acc: &mut u64) {
        match self {
            Instruction::Acc(i) => {
                *acc = (*acc as i64 + i.value) as u64;
                *ptr += 1;
                i.executed = true;
            },
            Instruction::Jmp(i) => {
                *ptr = (*ptr as i64 + i.value) as u32;
                i.executed = true;
            },
            Instruction::Nop(i) => {
                *ptr += 1;
                i.executed = true;
            }
        }
    }
}

#[derive(Debug)]
struct InstructionMetadata {
    value: i64,
    executed: bool
}

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let mut program: Vec<Instruction> = args[0].lines().map(|line| {
        let instruction_parts: Vec<&str> = line.split_terminator(' ').collect();
        let instruction_metadata = InstructionMetadata {
            value: instruction_parts[1].parse::<i64>().unwrap(), 
            executed: false
        };
        match instruction_parts[0] {
            "acc" => Instruction::Acc(instruction_metadata),
            "jmp" => Instruction::Jmp(instruction_metadata),
            "nop" => Instruction::Nop(instruction_metadata),
            _ => panic!("Instruction not recognized!")
        }
    }).collect();
    
    let mut current_ptr: u32 = 0;
    let mut accumulator: u64 = 0;

    while !program[current_ptr as usize].executed() {
        program[current_ptr as usize].execute(&mut current_ptr, &mut accumulator);
    }

    Ok(accumulator.to_string())
}

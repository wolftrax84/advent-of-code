#[derive(Debug)]
#[derive(Clone)]
pub struct Instruction {
    pub instr_type: InstructionType,
    pub value: i64,
    pub executed: bool
}

#[derive(Debug)]
#[derive(Clone)]
pub enum InstructionType {
    Acc,
    Jmp,
    Nop
}

impl Instruction {
    pub fn new(line: &str) -> Instruction {
        let instruction_parts: Vec<&str> = line.split_terminator(' ').collect();
        let instr_type = match instruction_parts[0] {
            "acc" => InstructionType::Acc,
            "jmp" => InstructionType::Jmp,
            "nop" => InstructionType::Nop,
            _ => panic!("Unsupported Instruction!")
        };
        let value = instruction_parts[1].parse::<i64>().unwrap();
        Instruction { instr_type, value, executed: false }
    }

    pub fn execute(&mut self, ptr: &mut u32, acc: &mut u64) {
        match self.instr_type {
            InstructionType::Acc => {
                *acc = (*acc as i64 + self.value) as u64;
                *ptr += 1;
            },
            InstructionType::Jmp => {
                *ptr = (*ptr as i64 + self.value) as u32;
            },
            InstructionType::Nop => {
                *ptr += 1;
            }
        }
        self.executed = true;
    }
}
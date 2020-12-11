mod computer;

use computer::{ Instruction, InstructionType };

pub fn run(args: &Vec<String>) -> Result<String, &'static str> {
    let program: Vec<Instruction> = args[0].lines().map(|line| { Instruction::new(line) }).collect();
    
    for i in 0..program.len() {
        let mut test_program = program.clone();
        match test_program[i].instr_type {
            InstructionType::Acc => (),
            InstructionType::Jmp => test_program[i].instr_type = InstructionType::Nop,
            InstructionType::Nop => test_program[i].instr_type = InstructionType::Jmp
        }
        if let Ok(accumulator) = execute_program(&mut test_program) {
            return Ok(accumulator.to_string());
        }
    }

    Err("No valid solutions!")
}

fn execute_program(program: &mut Vec<Instruction>) -> Result<u64, &'static str> {

    let mut current_ptr: u32 = 0;
    let mut accumulator: u64 = 0;

    loop {
        if current_ptr == program.len() as u32 {
            return Ok(accumulator)
        } else if program[current_ptr as usize].executed {
            return Err("Infinite loop found");
        } else {
            program[current_ptr as usize].execute(&mut current_ptr, &mut accumulator);
        }
    }
}

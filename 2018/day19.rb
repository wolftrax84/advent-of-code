def run_instruction(instruction, registers)
  opcode, parameters = instruction.split(" ", 2)
  parameters = parameters.split(" ").map(&:to_i)
  case opcode
  when "addr"
    registers[parameters[2]] = registers[parameters[0]] + registers[parameters[1]]
  when "addi"
    registers[parameters[2]] = registers[parameters[0]] + parameters[1]
  when "mulr"
    registers[parameters[2]] = registers[parameters[0]] * registers[parameters[1]]
  when "muli"
    registers[parameters[2]] = registers[parameters[0]] * parameters[1]
  when "banr"
    registers[parameters[2]] = registers[parameters[0]] & registers[parameters[1]]
  when "bani"
    registers[parameters[2]] = registers[parameters[0]] & parameters[1]
  when "borr"
    registers[parameters[2]] = registers[parameters[0]] | registers[parameters[1]]
  when "bori"
    registers[parameters[2]] = registers[parameters[0]] | parameters[1]
  when "setr"
    registers[parameters[2]] = registers[parameters[0]]
  when "seti"
    registers[parameters[2]] = parameters[0]
  when "gtir"
    registers[parameters[2]] = parameters[0] > registers[parameters[1]] ? 1 : 0
  when "gtri"
    registers[parameters[2]] = registers[parameters[0]] > parameters[1] ? 1 : 0
  when "gtrr"
    registers[parameters[2]] = registers[parameters[0]] > registers[parameters[1]] ? 1 : 0
  when "eqir"
    registers[parameters[2]] = parameters[0] == registers[parameters[1]] ? 1 : 0
  when "eqri"
    registers[parameters[2]] = registers[parameters[0]] == parameters[1] ? 1 : 0
  when "eqrr"
    registers[parameters[2]] = registers[parameters[0]] == registers[parameters[1]] ? 1 : 0
  end
end

def part1(input)
  instruction_register = input[0].chars.last.to_i
  instructions = input.slice(1, input.size - 1)
  registers = Array.new(6, 0)
  ip = 0
  loop do
    registers[instruction_register] = ip
    instruction = instructions[ip]
    run_instruction(instruction, registers)
    ip = registers[instruction_register]
    ip += 1
    break if ip >= instructions.size || ip == 1
  end
  return (1..registers[3]).select { |i| registers[3] % i == 0 }.sum
end

def part2(input)
  instruction_register = input[0].chars.last.to_i
  instructions = input.slice(1, input.size - 1)
  registers = Array.new(6, 0)
  registers[0] = 1
  ip = 0
  loop do
    registers[instruction_register] = ip
    instruction = instructions[ip]
    run_instruction(instruction, registers)
    ip = registers[instruction_register]
    ip += 1
    break if ip >= instructions.size || ip == 1
  end
  return (1..registers[3]).select { |i| registers[3] % i == 0 }.sum
end

actual = File.read("./day19.txt").lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

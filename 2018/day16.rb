class Opcode
  def initialize(name, input_1_type, input_2_type, function)
    @name = name
    @input_1_type = input_1_type
    @input_2_type = input_2_type
    @function = function
  end

  attr_accessor :name
  attr_accessor :input_1_type
  attr_accessor :input_2_type
  attr_accessor :function

  def test(registers_before, registers_after, operation)
    registers = *registers_before
    a = input_1_type == "reg" ? registers[operation[1].to_i] : operation[1].to_i
    b = input_2_type == "reg" ? registers[operation[2].to_i] : operation[2].to_i
    registers[operation[3].to_i] = send(@function, a, b)
    return registers == registers_after
  end

  def run(registers, operation)
    a = input_1_type == "reg" ? registers[operation[1].to_i] : operation[1].to_i
    b = input_2_type == "reg" ? registers[operation[2].to_i] : operation[2].to_i
    registers[operation[3].to_i] = send(@function, a, b)
  end
end

def add(a, b)
  return a + b
end

def multiply(a, b)
  return a * b
end

def and(a, b)
  return a & b
end

def or(a, b)
  return a | b
end

def assign(a, _)
  return a
end

def greater_than(a, b)
  return a > b ? 1 : 0
end

def equal(a, b)
  return a == b ? 1 : 0
end

$opcodes = []
$opcodes << Opcode.new("addr", "reg", "reg", :add)
$opcodes << Opcode.new("addi", "reg", "i", :add)
$opcodes << Opcode.new("mulr", "reg", "reg", :multiply)
$opcodes << Opcode.new("muli", "reg", "i", :multiply)
$opcodes << Opcode.new("banr", "reg", "reg", :and)
$opcodes << Opcode.new("bani", "reg", "i", :and)
$opcodes << Opcode.new("borr", "reg", "reg", :or)
$opcodes << Opcode.new("bori", "reg", "i", :or)
$opcodes << Opcode.new("setr", "reg", "reg", :assign)
$opcodes << Opcode.new("seti", "i", "reg", :assign)
$opcodes << Opcode.new("gtir", "i", "reg", :greater_than)
$opcodes << Opcode.new("gtri", "reg", "i", :greater_than)
$opcodes << Opcode.new("gtrr", "reg", "reg", :greater_than)
$opcodes << Opcode.new("eqir", "i", "reg", :equal)
$opcodes << Opcode.new("eqri", "reg", "i", :equal)
$opcodes << Opcode.new("eqrr", "reg", "reg", :equal)

def part1(input)
  op_count = 0
  input.each do |operation|
    matches = operation.match(/Before: \[?(\d+), ?(\d+), ?(\d+), ?(\d)\]\n?(\d+) ?(\d+) ?(\d+) ?(\d+)\nAfter:  \[?(\d+), ?(\d+), ?(\d+), ?(\d)\]/).to_a
    op_count += 1 if $opcodes.map { |opcode| opcode.test(matches[1, 4].map(&:to_i), matches[9, 4].map(&:to_i), matches[5, 4].map(&:to_i)) }.tally[true] > 2
  end
  return op_count
end

def part2(input1, input2)
  opcodes = *$opcodes
  op_keys = {}
  operations = []
  input1.each do |operation|
    matches = operation.match(/Before: \[?(\d+), ?(\d+), ?(\d+), ?(\d)\]\n?(\d+) ?(\d+) ?(\d+) ?(\d+)\nAfter:  \[?(\d+), ?(\d+), ?(\d+), ?(\d)\]/).to_a
    operations << [matches[1, 4].map(&:to_i), matches[9, 4].map(&:to_i), matches[5, 4].map(&:to_i)]
  end
  while op_keys.size < 16
    operations.each do |operation|
      next if op_keys.has_key?(operation[2][0])
      test_results = opcodes.map { |opcode| opcode.test(*operation) }
      if test_results.tally[true] == 1
        found_op_key = opcodes.delete_at(test_results.index(true))
        op_keys[operation[2][0]] = found_op_key
      end
    end
  end
  registers = [0, 0, 0, 0]
  input2.each do |operation|
    op = operation.split(" ").map(&:to_i)
    op_keys[op[0]].run(registers, op)
  end
  return registers[0]
end

actual = File.read("./day16.txt").split("\n\n\n\n")

puts part1(actual[0].chomp.split("\n\n"))
puts part2(actual[0].chomp.split("\n\n"), actual[1].chomp.lines.map(&:chomp))

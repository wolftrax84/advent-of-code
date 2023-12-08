def part1(input)
  instructions = input.shift.chomp.chars
  input.shift
  nodes = {}
  input.each do |line|
    k, l, r = line.scan(/([A-Z]{3})/).flatten
    nodes[k] = [l, r]
  end
  current_node = "AAA"
  iteration = 0
  loop do
    next_node = nodes[current_node][instructions[iteration % instructions.size] === "L" ? 0 : 1]
    break if next_node === "ZZZ"
    iteration += 1
    current_node = next_node
  end
  iteration + 1
end

def part2(input)
  instructions = input.shift.chomp.chars
  input.shift
  nodes = {}
  input.each do |line|
    k, l, r = line.scan(/([A-Z]{3})/).flatten
    nodes[k] = [l, r]
  end

  current_nodes = nodes.keys.select { |k| k.end_with? "A" }
  iteration = 0
  found_zs = []
  loop do
    next_nodes = []
    current_nodes.each do |node|
      next_node = nodes[node][instructions[iteration % instructions.size] === "L" ? 0 : 1]
      if next_node.end_with? "Z"
        found_zs << iteration + 1
      else
        next_nodes << next_node
      end
    end
    break if next_nodes.empty?
    iteration += 1
    current_nodes = next_nodes
  end
  found_zs.inject { |agg, cur| agg.lcm(cur) }
end

actual = File.read("./day8.txt").lines

puts part1(actual.clone)
puts part2(actual.clone)

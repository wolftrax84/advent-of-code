def get_sum_of_distances(input, expansion)
  galaxies = []
  columns = Array.new(input[0].size) { [] }

  expanded_rows = 0
  input.each.with_index do |line, row|
    expanded_rows += (expansion - 1) if !line.include?("#")
    line.chars.each.with_index do |c, column|
      columns[column] << c
      galaxies << [row + expanded_rows, column] if c == "#"
    end
  end

  expanded_columns = 0
  columns.each.with_index do |column, index|
    if column.all? { |c| c != "#" }
      galaxies.map! { |g| g[1] > index + (expanded_columns * (expansion - 1)) ? [g[0], g[1] + (expansion - 1)] : g }
      expanded_columns += 1
    end
  end

  galaxies.combination(2).map { |pair| ((pair[1][0] - pair[0][0]).abs() + (pair[1][1] - pair[0][1]).abs()) }.sum
end

def part1(input)
  get_sum_of_distances(input, 2)
end

def part2(input)
  get_sum_of_distances(input, 1000000)
end

actual = File.read("./day11.txt").lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

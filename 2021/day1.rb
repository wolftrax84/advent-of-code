def part1(input)
    return input.map(&:to_i).each_cons(2).filter { |a,b| b-a > 0}.length
end

def part2(input)
    return input.map(&:to_i).each_cons(3).map(&:sum).each_cons(2).filter { |a,b| b-a > 0}.length
end

actual = File.open("day1.txt").readlines

puts part1(actual)
puts part2(actual)

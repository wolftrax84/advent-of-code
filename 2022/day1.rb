def part1(input)
    return input.split(/\n\n/).map {|e| e.split(/\n/).map(&:to_i).sum}.max
end

def part2(input)
    return input.split(/\n\n/).map {|e| e.split(/\n/).map(&:to_i)}.map(&:sum).sort!.reverse!.take(3).sum
end

actual = File.read('./day1.txt')

puts part1(actual)
puts part2(actual)

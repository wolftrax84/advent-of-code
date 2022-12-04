def part1(input)
    input.select{ |pair|
        ranges = pair.split(',').map{|x| x.split('-').map(&:to_i)}.map {(_1.._2).to_a}
        ranges.map{|r| r.count}.include?(ranges[0].intersection(ranges[1]).count)
    }.count
end

def part2(input)
    input.select {|pair|
        ranges = pair.split(',').map{|x| x.split('-').map(&:to_i)}.map {(_1.._2).to_a}
        ranges[0].intersection(ranges[1]).count > 0
    }.count
end

actual = File.read('./day4.txt').lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

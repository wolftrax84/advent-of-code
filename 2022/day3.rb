def part1(input)
    input.map { |l| 
        match = l.shift(l.count/2).intersection(l)[0] 
        match > 90 ? match - 96 : match - 38
    }.sum
end

def part2(input)
    sum = 0
    input.each_slice(3) do |x,y,z|
        badge = (x & y & z)[0]
        sum += badge - (badge > 90 ? 96 : 38)
    end
    return sum
end

actual = File.read('./day3.txt').lines.map(&:chomp).map(&:codepoints)
actual2 = File.read('./day3.txt').lines.map(&:chomp).map(&:codepoints)

puts part1(actual)
puts part2(actual2)

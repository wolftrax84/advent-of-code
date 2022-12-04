def part1(input)
    input.select{ |pair|
        ranges = pair.split(',').map{|x| 
            limits = x.split('-').map(&:to_i)
            (limits[0]..limits[1]).to_a
        }
        ranges.map{|r| r.count}.include?(ranges[0].intersection(ranges[1]).count)
    }.count
end

def part2(input)
    input.select {|pair|
        ranges = pair.split(',').map{|x| 
            limits = x.split('-').map(&:to_i)
            (limits[0]..limits[1]).to_a
        }
        ranges[0].intersection(ranges[1]).count > 0
    }.count
end

actual = File.read('./day4.txt').lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

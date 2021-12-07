def part1(input)    
    crabs = input.split(?,).map(&:to_i).sort
    point = (crabs[(crabs.length - 1) / 2] + crabs[crabs.length / 2]) / 2.0
    return crabs.map {|c| c - point}.sum.to_i
end

def part2(input)
    crabs = input.split(?,).map(&:to_i)
    mean = (crabs.sum(0.0) / crabs.size)
    points = [mean.to_i, (mean+1).to_i]
    return points.map {|point| 
        crabs.map {|c| 
            (((c-point).abs+1)*(c-point).abs)/2
        }.sum.to_i 
    }.min.to_i
end

actual = File.open("day7.txt").read

puts part1(actual)
puts part2(actual)

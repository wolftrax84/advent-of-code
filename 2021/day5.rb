def part1(input)
    map = {}
    input.each do |line|
        x1,y1,x2,y2 = line.match(/([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)/).captures.map(&:to_i)
        if x1 == x2
            for z in (y2 > y1 ? y1..y2 : y2..y1)
                map[[x1,z]] = map[[x1,z]] != nil ? map[[x1,z]] + 1 : 1
            end    
        elsif y1 == y2
            for z in (x2 > x1 ? x1..x2 : x2..x1)
                map[[z,y1]] = map[[z,y1]] != nil ? map[[z,y1]] + 1 : 1
            end
        end
    end
    return map.values.count {|x| x >= 2}
end

def part2(input)
    map = {}
    input.each do |line|
        x1,y1,x2,y2 = line.match(/([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)/).captures.map(&:to_i)
        if x1 == x2
            for z in (y2 > y1 ? y1..y2 : y2..y1)
                map[[x1,z]] = map[[x1,z]] != nil ? map[[x1,z]] + 1 : 1
            end    
        elsif y1 == y2
            for z in (x2 > x1 ? x1..x2 : x2..x1)
                map[[z,y1]] = map[[z,y1]] != nil ? map[[z,y1]] + 1 : 1
            end
        else
            xDir = x1 > x2 ? -1 : 1
            yDir = y1 > y2 ? -1 : 1
            for b in 0..(x2 < x1 ? x1 - x2 : x2 - x1)
                map[[x1+(b*xDir),y1+(b*yDir)]] = map[[x1+(b*xDir),y1+(b*yDir)]] != nil ? map[[x1+(b*xDir),y1+(b*yDir)]] + 1 : 1
            end
        end
    end
    return map.values.count {|x| x >= 2}
end

actual = File.open("day5.txt").readlines

puts part1(actual)
puts part2(actual)

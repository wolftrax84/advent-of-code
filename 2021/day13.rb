def part1(input)
    inputSplitIdx = input.index("\n")
    points = input[0...inputSplitIdx].map {_1.chomp.split(?,).map(&:to_i)}
    directions = input[inputSplitIdx+1...input.length].map { |line| 
        line.chomp.split(" ")[2].split("=")
    }.map {[_1, _2.to_i]}

    axis, line = directions[0]
    points.each do |point|
        pointIndex = axis == "x" ? 0 : 1
        if point[pointIndex] > line
            point[pointIndex] = line - (point[pointIndex] - line)
        end
    end
    return points.uniq.length
end

def drawPoints(points)
    result = ""    
    for y in 0..points.map {_2}.flatten.max
        for x in 0..points.map {_1}.flatten.max
            result += points.include?([x,y]) ? "X" : " "
        end
        result += "\n"
    end
    return result
end

def part2(input)
    inputSplitIdx = input.index("\n")
    points = input[0...inputSplitIdx].map {_1.chomp.split(?,).map(&:to_i)}
    directions = input[inputSplitIdx+1...input.length].map { |line| 
        line.chomp.split(" ")[2].split("=")
    }.map {[_1, _2.to_i]}

    directions.each do |axis,line|
        points.each do |point|
            pointIndex = axis == "x" ? 0 : 1
            if point[pointIndex] > line
                point[pointIndex] = line - (point[pointIndex] - line)
            end
        end
    end
    return drawPoints(points)
end

actual = File.open("day13.txt").readlines

puts part1(actual)
puts part2(actual)

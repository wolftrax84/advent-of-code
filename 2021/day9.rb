def part1(input)
    height = input.length
    width = input[0].chomp.length
    risk = 0
    for x in 0...height
        for y in 0...width
            # up
            next if x > 0 && input[x][y] >= input[x-1][y] 
            # down
            next if x < height-1 && input[x][y] >= input[x+1][y]
            #left
            next if y > 0 && input[x][y] >= input[x][y-1]
            #right
            next if y < width-1 && input[x][y] >= input[x][y+1]
            risk += 1+input[x][y].to_i
        end
    end
    return risk
end

def part2(input)
    height = input.length
    width = input[0].chomp.length
    lowPoints = []
    for x in 0...height
        for y in 0...width
            # up
            next if x > 0 && input[x][y] >= input[x-1][y] 
            # down
            next if x < height-1 && input[x][y] >= input[x+1][y]
            #left
            next if y > 0 && input[x][y] >= input[x][y-1]
            #right
            next if y < width-1 && input[x][y] >= input[x][y+1]
            lowPoints << [x,y]
        end
    end

    sizes = lowPoints.map do |low|
        size = 1
        checked = [low]
        checkPoints = [low]
        while checkPoints.length > 0
            x,y = checkPoints.shift
            #up
            if x > 0 && !checked.include?([x-1,y])
                if input[x-1][y] != "9"
                    size += 1
                    checkPoints << [x-1,y]
                    checked << [x-1,y]
                end
            end
            #down
            if x < height-1  && !checked.include?([x+1,y])
                if input[x+1][y] != "9"
                    size += 1
                    checkPoints << [x+1,y]
                    checked << [x+1,y]
                end
            end
            #left
            if y > 0 && !checked.include?([x,y-1])
                if input[x][y-1] != "9"
                    size += 1
                    checkPoints << [x,y-1]
                    checked << [x,y-1]
                end
            end
            #right
            if y < width-1 && !checked.include?([x,y+1])
                if input[x][y+1] != "9"
                    size += 1
                    checked << [x,y+1]
                    checkPoints << [x,y+1]
                end
            end
        end
        size
    end
    return sizes.sort.reverse.shift(3).inject(:*)
end

actual = File.open("day9.txt").readlines

puts part1(actual)
puts part2(actual)

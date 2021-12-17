def part1(input)
    x1,x2,y1,y2 = input.match(/target area: x=(-*[0-9]+)\.\.(-*[0-9]+), y=(-*[0-9]+)\.\.(-*[0-9]+)/).captures.map(&:to_i)
    return y1.abs*(y1.abs-1)/2
end

def hitTarget(xStart, yStart, x1,x2,y1,y2)
    xv = xStart
    yv = yStart
    x = y = 0
    while x <= x2 && y >= y1
        if x >= x1 && y <= y2
            return true
        end
        x += xv
        y += yv
        xv -= xv == 0 ? 0 : 1
        yv -= 1
    end
    return false
end

def part2(input)
    x1,x2,y1,y2 = input.match(/target area: x=(-*[0-9]+)\.\.(-*[0-9]+), y=(-*[0-9]+)\.\.(-*[0-9]+)/).captures.map(&:to_i)
    xRange = (1..x2)
    yRange = (y1..y1.abs)
    hits = 0
    for xStart in xRange
        for yStart in yRange
            if hitTarget(xStart, yStart, x1,x2,y1,y2)
                hits += 1
            end
        end
    end
    return hits
end

actual = File.open("day17.txt").read

test1 = "target area: x=20..30, y=-10..-5"

puts part1(actual)
puts part2(actual)

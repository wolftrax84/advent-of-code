def part1(input)
    claims = input.map do |c|
        c.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/).captures.map(&:to_i)
    end
    fabric = Hash.new(0)
    claims.each do |c|
        a = *(c[1]...(c[1]+c[3]))
        b = *(c[2]...(c[2]+c[4]))
        a.product(b).each {|x,y| fabric["#{x}|#{y}"] += 1 }
    end
    return fabric.count {|k,v| v > 1}
end

def overlap(box1, box2)
    fabric = Hash.new(0)
    [box1,box2].each do |c|
        for x in c[1]...(c[1]+c[3])
            for y in c[2]...(c[2]+c[4])
                fabric["#{x}|#{y}"] += 1
            end
        end
    end
    return fabric.any? {|k,v| v > 1}
end

def part2(input)
    claims = input.map do |c|
        c.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/).captures.map(&:to_i)
    end
    fabric = Hash.new(0)
    claims.each do |c|
        a = *(c[1]...(c[1]+c[3]))
        b = *(c[2]...(c[2]+c[4]))
        a.product(b).each {|x,y| fabric["#{x}|#{y}"] += 1 }
    end
    claims.each do |c|
        a = *(c[1]...(c[1]+c[3]))
        b = *(c[2]...(c[2]+c[4]))
        next if a.product(b).any? {|x,y| fabric["#{x}|#{y}"] > 1 }
        return c[0]
    end
end

actual = File.read("./day3.txt").lines

puts part1(actual)
puts part2(actual)
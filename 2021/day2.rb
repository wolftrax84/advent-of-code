def part1(input)
    h = 0
    d = 0
    input.map{|x| x.split " "}.each {
        case _1
        when "forward"
            h += _2.to_i
        when "up"
            d -= _2.to_i
        when "down"
            d += _2.to_i
        end
    }
    return h * d
end

def part2(input)
    a = 0
    h = 0
    d = 0
    input.map{|x| x.split " "}.each {
        case _1
        when "forward"
            h += _2.to_i
            d += a * _2.to_i
        when "up"
            a -= _2.to_i
        when "down"
            a += _2.to_i
        end
    }
    return h * d
end

actual = File.open("day2.txt").readlines

puts part1(actual)
puts part2(actual)

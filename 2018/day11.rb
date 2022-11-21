require 'matrix'

def part1(input)
    m = Matrix.build(300,300) {|row,col| (((((col + 10) * (row +0 )) + input) * (col + 10)) %  1000 / 100).floor() - 5}
    max_key = 0
    max_power = -100
    (0..277).to_a().product((0..277).to_a()).each do |(x,y)|
        test = m[x,y]+m[x+1,y]+m[x+2,y]+m[x,y+1]+m[x+1,y+1]+m[x+2,y+1]+m[x,y+2]+m[x+1,y+2]+m[x+2,y+2] 
        if test > max_power
            max_key = "#{y},#{x}" 
            max_power = test
        end
    end
    return max_key
end

def part2(input)
    m = Matrix.build(301,301) {|row,col| (((((col + 10) * (row +0 )) + input) * (col + 10)) %  1000 / 100).floor() - 5}
    m = m.minor(1..300,1..300)
    m2 = Matrix.zero(300)
    (0...300).each do |y|
        (0...300).each do |x|
            a = x == 0 || y == 0 ? 0 : m2[x-1,y-1]
            b = y == 0 ? 0 : m2[x,y-1]
            c = x == 0 ? 0 : m2[x-1,y]
            d = m[x,y]
            m2[x,y] = m[x,y] + b + c - a
        end
    end
    max = 0
    max_coords = [0,0]
    max_size = 0
    (1..300).each do |size|
        size_down = size - 1
        (size_down...300).each do |y|
            (size_down...300).each do |x|
                a = x == size_down || y == size_down ? 0 : m2[x-size,y-size]
                b = y == size_down ? 0 : m2[x,y-size]
                c = x == size_down ? 0 : m2[x-size,y]
                val = m2[x,y] + a - b - c
                if val > max
                    max = val
                    max_coords = [y-size_down,x-size_down]
                    max_size = size
                end
            end
        end
    end
    return "#{max_coords[0]+1},#{max_coords[1]+1},#{max_size}"
end

puts part1(9306)
puts part2(9306)

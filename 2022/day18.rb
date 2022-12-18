def part1(input)
    total_sides = input.length * 6
    input.combination(2).each do |p1,p2|
        total_sides -= 2 if ((p1[0]-p2[0]).abs + (p1[1]-p2[1]).abs + (p1[2]-p2[2]).abs) == 1
    end
    total_sides
end

def surrounded(input, x,y,z)
    if input.any?{|p| p[0] == x && p[1] == y && p[2] > z}
        if input.any?{|p| p[0] == x && p[1] == y && p[2] < z}
            if input.any?{|p| p[0] < x && p[1] == y && p[2] == z}
                if input.any?{|p| p[0] > x && p[1] == y && p[2] == z}
                    if input.any?{|p| p[0] == x && p[1] < y && p[2] == z}
                        if input.any?{|p| p[0] == x && p[1] > y && p[2] == z}
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

def part2(input)
    total_sides = part1(input)
    min_x, max_x = [input.map{|p| p[0]}.min,input.map{|p| p[0]}.max]
    min_y, max_y = [input.map{|p| p[1]}.min,input.map{|p| p[1]}.max]
    min_z, max_z = [input.map{|p| p[2]}.min,input.map{|p| p[2]}.max]
    
    surrounded_cubes = []
    ((min_x+1)...max_x).each do |x|
        ((min_y+1)...max_y).each do |y|
            ((min_z+1)...max_z).each do |z|
                next if input.include?([x,y,z])
                surrounded_cubes << [x,y,z] if surrounded(input, x,y,z)
            end
        end
    end
    loop do
        next_cubes = []
        surrounded_cubes.each do |c|
            next if !surrounded_cubes.include?([c[0],c[1],c[2]+1]) && !input.include?([c[0],c[1],c[2]+1])
            next if !surrounded_cubes.include?([c[0],c[1],c[2]-1]) && !input.include?([c[0],c[1],c[2]-1])
            next if !surrounded_cubes.include?([c[0],c[1]+1,c[2]]) && !input.include?([c[0],c[1]+1,c[2]])
            next if !surrounded_cubes.include?([c[0],c[1]-1,c[2]]) && !input.include?([c[0],c[1]-1,c[2]])
            next if !surrounded_cubes.include?([c[0]+1,c[1],c[2]]) && !input.include?([c[0]+1,c[1],c[2]])
            next if !surrounded_cubes.include?([c[0]-1,c[1],c[2]]) && !input.include?([c[0]-1,c[1],c[2]])
            next_cubes << c
        end
        break if surrounded_cubes.count == next_cubes.count
        surrounded_cubes = next_cubes.clone
    end
    contained_sides = part1(surrounded_cubes)
    total_sides - contained_sides
end

actual = File.read('./day18.txt').lines.map{|l| l.split(',').map(&:to_i)}

puts part1(actual)
puts part2(actual)

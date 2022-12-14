def part1(input)
    lowest_point = 0
    map = {}
    input.each do |l|
        segments = l.split(" -> ").map{ |x| x.split(',').map(&:to_i)}
        (0...(segments.count-1)).each do |i|
            x_points = [segments[i].first, segments[i+1].first]
            y_points = [segments[i].last, segments[i+1].last]
            (x_points.min..x_points.max).each do |i|
                (y_points.min..y_points.max).each do |j|
                    lowest_point = j if j > lowest_point
                    map[[i,j]] = "#"
                end
            end
        end
    end
    loop do
        current_pos = [500,0]
        loop do
            # try down
            next_pos = [current_pos[0], current_pos[1]+1]
            if !map.has_key?(next_pos)
                return map.values.tally["o"] if next_pos[1] == lowest_point
                current_pos = next_pos
                next
            end
            # try left
            next_pos = [current_pos[0]-1,current_pos[1]+1]
            if !map.has_key?(next_pos)
                return map.values.tally["o"] if next_pos[1] == lowest_point
                current_pos = next_pos
                next
            end
            # try right
            next_pos = [current_pos[0]+1,current_pos[1]+1]
            if !map.has_key?(next_pos)
                return map.values.tally["o"] if next_pos[1] == lowest_point
                current_pos = next_pos
                next
            end
            map[current_pos] = "o"
            break
        end
    end
end

def part2(input)
    lowest_point = 0
    map = {}
    input.each do |l|
        segments = l.split(" -> ").map{ |x| x.split(',').map(&:to_i)}
        (0...(segments.count-1)).each do |i|
            x_points = [segments[i].first, segments[i+1].first]
            y_points = [segments[i].last, segments[i+1].last]
            (x_points.min..x_points.max).each do |i|
                (y_points.min..y_points.max).each do |j|
                    lowest_point = j if j > lowest_point
                    map[[i,j]] = "#"
                end
            end
        end
    end
    lowest_point += 1
    loop do
        current_pos = [500,0]
        loop do
            # try down
            next_pos = [current_pos[0], current_pos[1]+1]
            if !map.has_key?(next_pos)
                if next_pos[1] == lowest_point
                    map[next_pos] = "o"
                    break
                end
                current_pos = next_pos
                next
            end
            # try left
            next_pos = [current_pos[0]-1,current_pos[1]+1]
            if !map.has_key?(next_pos)
                if next_pos[1] == lowest_point
                    map[next_pos] = "o"
                    break
                end
                current_pos = next_pos
                next
            end
            # try right
            next_pos = [current_pos[0]+1,current_pos[1]+1]
            if !map.has_key?(next_pos)
                if next_pos[1] == lowest_point
                    map[next_pos] = "o"
                    break
                end
                current_pos = next_pos
                next
            end
            map[current_pos] = "o"
            return map.values.tally["o"] if current_pos == [500,0]
            break
        end
    end
end

actual = File.read('./day14.txt').lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

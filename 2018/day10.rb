def getBoundingBox(points)
    col_min_max = points.minmax_by {|p| p[0]}.map {|p| p[0]}
    width = col_min_max[1] - col_min_max[0]
    row_min_max = points.minmax_by {|p| p[1]}.map {|p| p[1]}
    height = row_min_max[1] - row_min_max[0]
    [width * height, col_min_max, row_min_max]
end

def part1(input)
    points = input.map {|l| l.chomp.match(/position=<\s*(-*\d+),\s*(-*\d+)> velocity=<\s*(-*\d+),\s*(-*\d+)>/).captures.map(&:to_i)}
    bounding_box = getBoundingBox(points)
    catch :found_smallest_box do
        loop do
            next_points = points.map {|p| [p[0]+p[2], p[1]+p[3], p[2], p[3]]}
            next_bounding_box = getBoundingBox(next_points)
            throw :found_smallest_box if next_bounding_box[0] > bounding_box[0]
            bounding_box = next_bounding_box
            points = next_points
        end
    end
    points.map! {|p| [p[0], p[1]]}
    output = ""
    for row in bounding_box[2][0]..bounding_box[2][1]
        for col in bounding_box[1][0]..bounding_box[1][1]
            output += (points.include? ([col,row])) ? '#' : ' '
        end
        output += "\n"
    end
    output
end

def part2(input)
    points = input.map {|l| l.chomp.match(/position=<\s*(-*\d+),\s*(-*\d+)> velocity=<\s*(-*\d+),\s*(-*\d+)>/).captures.map(&:to_i)}
    seconds = 0
    bounding_box = getBoundingBox(points)
    catch :found_smallest_box do
        loop do
            next_points = points.map {|p| [p[0]+p[2], p[1]+p[3], p[2], p[3]]}
            next_bounding_box = getBoundingBox(next_points)
            throw :found_smallest_box if next_bounding_box[0] > bounding_box[0]
            bounding_box = next_bounding_box
            points = next_points
            seconds += 1
        end
    end
    seconds
end

actual = File.read('./day10.txt').lines

puts part1(actual)
puts part2(actual)

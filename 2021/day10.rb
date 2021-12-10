def part1(input)
    points = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }
    match = { "(" => ")", "{" => "}", "[" => "]", "<" => ">" }
    error = 0
    input.each do |line|
        queue = []
        line.chomp.chars.each do |c|
            if match.keys.include?(c)
                queue.push(c)
            else
                if match[queue.last] == c
                    queue.pop
                else
                    error += points[c]
                    break
                end
            end
        end
    end
    return error
end

def part2(input)
    points = { ")" => 1, "]" => 2, "}" => 3, ">" => 4 }
    match = { "(" => ")", "{" => "}", "[" => "]", "<" => ">" }
    scores = []
    input.each.with_index do |line,i|
        catch :corruptLine do
            queue = []
            line.chomp.chars.each do |c|
                if match.keys.include?(c)
                    queue.push(c)
                else
                    if match[queue.last] == c
                        queue.pop
                    else
                        throw :corruptLine
                    end
                end
            end
            scores << queue.reverse.map {|x| points[match[x]]}.reduce(0) {|total, value| total*5+value}
        end
    end
    return scores.sort![(scores.length/2).ceil]
end

actual = File.open("day10.txt").readlines

puts part1(actual)
puts part2(actual)

def part1(input)
    score = 0
    input.each do |l|
        p1, p2 = l.split(' ')
        case p2
        when "X"
            score += 1
            case p1
            when "A"
                score += 3
            when "C"
                score += 6
            end
        when "Y"
            score += 2
            case p1
            when "A"
                score += 6
            when "B"
                score += 3
            end
        when "Z"
            score += 3
            case p1
            when "B"
                score += 6
            when "C"
                score += 3
            end
        end
    end
    score
end

def part2(input)
    score = 0
    input.each do |l|
        p1, p2 = l.split(' ')
        case p2
        when "X"
            case p1
            when "A"
                score += 3
            when "B"
                score += 1
            when "C"
                score += 2
            end
        when "Y"
            score += 3
            case p1
            when "A"
                score += 1
            when "B"
                score += 2
            when "C"
                score += 3
            end
        when "Z"
            score += 6
            case p1
            when "A"
                score += 2
            when "B"
                score += 3
            when "C"
                score += 1
            end
        end
    end
    score
end

actual = File.read('./day2.txt').lines

puts part1(actual)
puts part2(actual)

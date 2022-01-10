def part1(input)
    twos = 0
    threes = 0
    input.each do |line|
        tally = line.chars.tally
        twos += 1 if tally.values.any?{|x| x == 2}
        threes += 1 if tally.values.any?{|x| x == 3}
    end
    return twos * threes
end

def oneDiff(pair)
    diffs = -1
    pair[0].chars.each.with_index do |c,idx|
        if c != pair[1][idx]
            if diffs != -1
                return -1
            else
                diffs = idx
            end
        end
    end
    return diffs
end

def part2(input)
    input.combination(2).each do |pair|
        diff = oneDiff(pair)
        if diff != -1
            pair[0].slice!(diff)
            return pair[0]
        end
    end
end

actual = File.read("./day2.txt").lines

puts part1(actual)
puts part2(actual)
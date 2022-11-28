def part1(input)
    idx1 = 0
    idx2 = 1
    scores = [3,7]
    # puts 
    loop do
        scores.concat((scores[idx1]+scores[idx2]).digits.reverse)
        idx1 = ((idx1 + 1 + scores[idx1]) % scores.count)
        idx2 = ((idx2 + 1 + scores[idx2]) % scores.count)
        break if scores.count == 10 + input
    end
    return scores[input..].join
end

def part2(input)
    idx1 = 0
    idx2 = 1
    scores = "37"
    loop do
        score1 = scores[idx1].to_i
        score2 = scores[idx2].to_i
        scores << (score1+score2).to_s
        score_length = scores.length
        if score_length > 8 && (scores.slice(-8,score_length-1)).include?(input)
            return scores.index(input)
        end
        idx1 = ((idx1 + 1 + score1) % score_length)
        idx2 = ((idx2 + 1 + score2) % score_length)
    end
end

actual = 702831

puts part1(actual)
puts part2(actual.to_s)

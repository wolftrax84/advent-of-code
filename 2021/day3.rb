def getBitCriteria(input, bias)    
    range = 0...input[0].length
    ones = range.map {|i| input.count {|l| l[i] == "1"}}
    zeros = range.map {|i| input.count {|l| l[i] == "0"}}
    gamma = range.map {|i| ones[i] == zeros[i] ? bias : ones[i] > zeros[i] ? "1" : "0" }.join("")
    epsilon = range.map {|i| ones[i] == zeros[i] ? bias : ones[i] < zeros[i] ? "1" : "0" }.join("")
    return [gamma, epsilon]
end

def part1(input)
    gamma, epsilon = getBitCriteria(input.map!(&:chomp), "1")
    return gamma.to_i(2) * epsilon.to_i(2)
end

def part2(input)
    input.map!(&:chomp)
    idx = 0
    o2Candidates = input.clone
    co2Candidates = input.clone
    while o2Candidates.length > 1 || co2Candidates.length > 1
        if o2Candidates.length > 1
            o2BitCriteria = getBitCriteria(o2Candidates, "1")[0]
            o2Candidates.filter!{ |c| c[idx] == o2BitCriteria[idx] }
        end
        if co2Candidates.length > 1
            co2BitCriteria = getBitCriteria(co2Candidates, "0")[1]
            co2Candidates.filter!{ |c| c[idx] == co2BitCriteria[idx] }
        end
        idx += 1
    end
    return o2Candidates[0].to_i(2) * co2Candidates[0].to_i(2)
end

actual = File.open("day3.txt").readlines

puts part1(actual)
puts part2(actual)

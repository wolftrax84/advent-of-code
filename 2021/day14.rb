def part1(input)
    template = input[0].chomp
    rules = Hash.new()
    input[2...input.length].each {|x| 
        a,b = x.chomp.split(" -> ")
        rules[a] = b
    }
    10.times do
        pairs = template.chars.filter_map.with_index {|x, idx| idx < template.length-1 ? template[idx..idx+1] : nil }
        pairs.each.with_index {|pair,idx|
            template.insert(2*idx+1,rules[pair])
        }
    end
    tally = template.chars.tally    
    return tally.values.max - tally.values.min
end

$maxDepth = 40
$cache = Hash.new()

def getSubString(pair, rules, depth) 
    if depth == $maxDepth
        return pair.chars.tally
    elsif $cache[[pair,depth]] != nil
        return $cache[[pair,depth]]
    end
    tally = Hash.new()
    tally.merge!(getSubString(pair[0]+rules[pair], rules, depth+1)) {|k,o,n| o + n}
    tally.merge!(getSubString(rules[pair]+pair[1], rules, depth+1)) {|k,o,n| o + n}
    tally[rules[pair]] -= 1
    $cache[[pair,depth]] = tally
    return tally
end

def part2(input)
    template = input[0].chomp
    rules = Hash.new()
    input[2...input.length].map {|x| 
        a,b = x.chomp.split(" -> ")
        rules[a] = b
    }

    pairs = template.chars.each_cons(2).map(&:join)
    tallies = Hash.new()
    tallies.merge!(*pairs.map {|x| getSubString(x, rules, 0)}){|k,o,n| o+n}
    template[1...template.length-1].chars.each do |c|
        tallies[c] -= 1
    end

    return tallies.values.max - tallies.values.min
end

actual = File.open("day14.txt").readlines

puts part1(actual)
puts part2(actual)

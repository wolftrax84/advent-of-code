def part1(current, rules, start_rules)
    zero = 0
    20.times do
        next_layout = current.map(&:clone)

        # index 0
        idx0 = "..#{current[0...3].join}"
        next_layout[0] = rules[idx0]

        # index 1
        idx1 = ".#{current[0...4].join}"
        next_layout[1] = rules[idx1]

        # indicies 2..-3
        (2..(current.count-3)).each do |i|
            idx = current[(i-2)..(i+2)].join
            next_layout[i] = rules[idx]
        end

        # index -2
        idxl2 = "#{current[-4..].join}."
        next_layout[-2] = rules[idxl2]

        # index -1
        idxl1 = "#{current[-3..].join}.."
        next_layout[-1] = rules[idxl1]

        # overflow right
        idxRight = "#{current[-2..].join}..."
        next_layout.push(rules[idxRight])

        # overflow left
        idxLeft = current[0..1].join
        if start_rules.include?(idxLeft)
            next_layout.prepend('#')
            zero += 1
        end
        current = next_layout
    end
    result = 0
    current.each.with_index do |x,i|
        if x == '#'
            result += i - zero
        end
    end
    return result
end

def part2(current, rules, start_rules)
    zero = 0
    last_result = 0
    last_diff = 0
    result = 0
    i = 0
    50000000000.times do
        i += 1
        next_layout = current.map(&:clone)

        # index 0
        idx0 = "..#{current[0...3].join}"
        next_layout[0] = rules[idx0]

        # index 1
        idx1 = ".#{current[0...4].join}"
        next_layout[1] = rules[idx1]

        # indicies 2..-3
        (2..(current.count-3)).each do |i|
            idx = current[(i-2)..(i+2)].join
            next_layout[i] = rules[idx]
        end

        # index -2
        idxl2 = "#{current[-4..].join}."
        next_layout[-2] = rules[idxl2]

        # index -1
        idxl1 = "#{current[-3..].join}.."
        next_layout[-1] = rules[idxl1]

        # overflow right
        idxRight = "#{current[-2..].join}..."
        next_layout.push(rules[idxRight])

        # overflow left
        idxLeft = current[0..1].join
        if start_rules.include?(idxLeft)
            next_layout.prepend('#')
            zero += 1
        end
        
        result = 0
        next_layout.each.with_index do |x,i|
            if x == '#'
                result += i - zero
            end
        end
        break if (result - last_result) == last_diff
        last_diff = result - last_result
        last_result = result
        current = next_layout
    end
    return (50000000000-i)*last_diff+result
end

actual = File.read('./day12.txt').lines.map(&:chomp)
initial = actual[0].split(': ')[1].chars
rules = actual[2..].map{|rule| rule.split(' => ')}
start_rules = rules.select{|e| e[0].start_with?('...') && e[1] == '#'}.map{|e| [e[0].chars[3..].join,e[1]]}
rule_set = {}
rules.each do |k,v|
    rule_set[k] = v
end
start_rule_set = {}
start_rules.each do |k,v|
    start_rule_set[k] = v
end

puts part1(initial, rule_set, start_rule_set)
puts part2(initial, rule_set, start_rule_set)

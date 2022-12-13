def is_i? (c)
    return c.to_i.to_s == c
end

def compare_lists(one, two)
    i1 = -1
    i2 = -1
    loop do 
        i1 += 1
        i2 += 1
        i1 += 1 if one[i1] == ","
        i2 += 1 if two[i2] == ","
        if one[i1] == two[i2]
            next
        elsif is_i?(one[i1]) && is_i?(two[i2])
            num1 = one[i1].to_i
            if is_i?(one[i1+1])
                num1 = one[i1..i1+1].to_i
                i1 += 1
            end
            num2 = two[i2].to_i
            if is_i?(two[i2+1])
                num2 = two[i2..i2+1].to_i
                i2 += 1
            end
            return num1 < num2 ? true : false
        elsif one[i1] == "]"
            return true
        elsif two[i2] == "]"
            return false
        elsif one[i1] == "["
            if is_i?(one[i1+1])
                two[i2..i2+1] = "[#{two[i2..i2+1]}]"
            else
                two[i2..i2] = "[#{two[i2]}]"
            end
            next
        elsif two[i2] == "["
            if is_i?(one[i1+1])
                one[i1..i1+1] = "[#{one[i1..i1+1]}]"
            else
                one[i1..i1] = "[#{one[i1]}]"
            end
        end
    end
end

def part1(input)
    pairs = input.split("\n\n").map{|r| r.lines.map(&:chomp)}
    return pairs.map.with_index { |pair|
        compare_lists(pair[0], pair[1])
    }.map.with_index {|x,i| x == true ? i+1 : 0}.sum
end

def part2(input)
    pairs = input.split("\n\n").map{|r| r.lines.map(&:chomp)}.flatten
    pairs.unshift("[[2]]","[[6]]")
    pairs.sort! {|a,b| compare_lists(a.clone,b.clone) == true ? -1 : 1 }
    return (pairs.index("[[2]]")+1) * (pairs.index("[[6]]")+1)
end

actual = File.read('./day13.txt')

puts part1(actual)
puts part2(actual)

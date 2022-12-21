def dfs1(monkeys, current)
    if monkeys[current].count == 1
        return monkeys[current][0].to_i
    else
        return eval("#{dfs1(monkeys, monkeys[current][0])} #{monkeys[current][1]} #{dfs1(monkeys, monkeys[current][2])}")
    end
end

def part1(input)
    monkeys = Hash.new{|h,k| h[k] = []}
    input.each do |l|
        name, rest = l.split(": ")
        monkeys[name] = rest.split
    end
    return dfs1(monkeys, 'root')
end

def dfs2(monkeys, current)
    if current == "humn"
        return "x"
    elsif monkeys[current].count == 1
        return monkeys[current][0].to_i
    else
        val1 = dfs2(monkeys, monkeys[current][0])
        val2 = dfs2(monkeys, monkeys[current][2])
        if !val1.is_a?(Numeric) || !val2.is_a?(Numeric)
            return [val1, monkeys[current][1], val2]
        else
            return eval("#{val1} #{monkeys[current][1]} #{val2}")
        end
    end
end

def flip_op(op)
    case op
    when '+' 
        return '-'
    when '*' 
        return '/'
    when '-' 
        return '+'
    when '/' 
        return '*'
    end
end

def solve_for_x(left_side, right_side)
    loop do
        if left_side[0].is_a?(Numeric)
            if !["+","*"].include?(left_side[1])
                left_side[0], right_side = [right_side, left_side[0]]
                left_side[1] = left_side[1] == "/" ? "*" : "+"
            end
            right_side = eval("#{right_side} #{flip_op(left_side[1])} #{left_side[0]}")
            if left_side[2] == "x"
                return right_side
            else
                left_side = left_side[2]
            end
        else
            right_side = eval("#{right_side} #{flip_op(left_side[1])} #{left_side[2]}")
            if left_side[0] == "x"
                return right_side
            else
                left_side = left_side[0]
            end
        end
    end
end

def part2(input)
    monkeys = Hash.new{|h,k| h[k] = []}
    input.each do |l|
        name, rest = l.split(": ")
        monkeys[name] = rest.split
    end

    val1 = dfs2(monkeys, monkeys["root"][0])
    val2 = dfs2(monkeys, monkeys["root"][2])
    if val1.is_a?(Array)
        return solve_for_x(val1,val2)
    else
        return solve_for_x(val2,val1)
    end
end

actual = File.read('./day21.txt').lines

puts part1(actual)
puts part2(actual)
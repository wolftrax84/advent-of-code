class Monkey
    def initialize(items, op, test_op, true_monkey, false_monkey)
      @items = items
      @op = op
      @test_op = test_op
      @true_monkey = true_monkey
      @false_monkey = false_monkey
    end

    attr_accessor :items
    attr_accessor :op
    attr_accessor :test_op
    attr_accessor :true_monkey
    attr_accessor :false_monkey
end

def part1(monkeys)
    monkey_counts = Array.new(monkeys.count, 0)
    20.times do
        monkeys.each.with_index do |m,i|
            monkey_counts[i] += m.items.count
            loop do
                break if m.items.count == 0
                item = m.items.shift
                operand = m.op[1] == "old" ? item : m.op[1]
                case m.op[0]
                when "*"
                    item = item * operand
                when "+"
                    item = item + operand
                end
                item = item / 3
                next_monkey = item % m.test_op == 0 ? m.true_monkey : m.false_monkey
                monkeys[next_monkey].items << item
            end
        end
    end
    monkey_counts.sort.reverse.take(2).inject(:*)
end

def part2(monkeys)
    monkey_counts = Array.new(monkeys.count, 0)
    coefficient = monkeys.map{|m| m.test_op}.inject(:*)
    10000.times do
        monkeys.each.with_index do |m,i|
            monkey_counts[i] += m.items.count
            loop do
                break if m.items.count == 0
                item = m.items.shift
                operand = m.op[1] == "old" ? item : m.op[1]
                case m.op[0]
                when "*"
                    item = item * operand
                when "+"
                    item = item + operand
                end
                item %= coefficient
                next_monkey = item % m.test_op == 0 ? m.true_monkey : m.false_monkey
                monkeys[next_monkey].items << item
            end
        end
    end
    monkey_counts.sort.reverse.take(2).inject(:*)
end

actual = File.read('./day11.txt').split("\n\n")
monkeys1 = actual.map{|m| 
    caps = m.match(/.*items:(.+)\n.*((?:\*|\+) (?:\d+|old)).* (\d+).* (\d+).* (\d+)/m).captures
    Monkey.new(
        caps[0].split(",").map(&:to_i), 
        caps[1].split.map{|x| x.to_i.to_s == x ? x.to_i : x}, 
        caps[2].to_i, 
        caps[3].to_i, 
        caps[4].to_i)
}
monkeys2 = monkeys1.map{|m| m.clone}

puts part1(monkeys1)
puts part2(monkeys2)

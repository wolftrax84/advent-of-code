def part1(input)
  input.map { |line|
    lists = []
    lists << line.scan(/(-*\d+)/).flatten.map(&:to_i)

    loop do
      break if !lists.first.any? { |x| x != 0 }
      next_list = lists.first.each_cons(2).map { |pair| (pair[1] - pair[0]) }
      lists.unshift(next_list)
    end

    (1...lists.size).each.with_index do |i|
      lists[i] << lists[i].last + lists[i - 1].last
    end
    lists.last.last
  }.sum
end

def part2(input)
  input.map { |line|
    lists = []
    lists << line.scan(/(-*\d+)/).flatten.map(&:to_i)

    loop do
      break if !lists.first.any? { |x| x != 0 }
      next_list = lists.first.each_cons(2).map { |pair| (pair[1] - pair[0]) }
      lists.unshift(next_list)
    end

    (1...lists.size).each.with_index do |i|
      lists[i].unshift(lists[i].first - lists[i - 1].first)
    end
    lists.last.first
  }.sum
end

actual = File.read("./day9.txt").lines

puts part1(actual)
puts part2(actual)

def getNum(val)
  case val
  when "one"
    return 1
  when "two"
    return 2
  when "three"
    return 3
  when "four"
    return 4
  when "five"
    return 5
  when "six"
    return 6
  when "seven"
    return 7
  when "eight"
    return 8
  when "nine"
    return 9
  else
    return val.to_i
  end
end

def part1(input)
  total = 0
  input.each do |line|
    numbers = line.scan(/(\d)/).flatten
    total += getNum(numbers.first) * 10 + getNum(numbers.last)
  end
  return total
end

def part2(input)
  total = 0
  input.each do |line|
    matches = line.scan(/(one|two|three|four|five|six|seven|eight|nine|\d)/).flatten
    total += getNum(matches.first) * 10 + getNum(matches.last)
  end
  return total
end

actual = File.read("./day1.txt").lines

puts part1(actual)
puts part2(actual)

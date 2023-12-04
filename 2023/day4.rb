def part1(input)
  input.map { |line|
    parts = line.split(":")[1].split("|")
    winning_numbers = Set.new(parts[0].scan(/\d+/))
    numbers = Set.new(parts[1].scan(/\d+/))
    amount = (numbers & winning_numbers).size
    amount > 0 ? 2 ** (amount - 1) : 0
  }.sum
end

def part2(input)
  card_counts = {}
  (1..input.size).each { |key| card_counts[key] = 1 }
  input.each.with_index do |line, card_number|
    parts = line.split(":")[1].split("|")
    winning_numbers = Set.new(parts[0].scan(/\d+/))
    numbers = Set.new(parts[1].scan(/\d+/))
    amount = (numbers & winning_numbers).size
    (card_number + 2..card_number + 1 + amount).each do |card_copy|
      card_counts[card_copy] += card_counts[card_number + 1]
    end
  end
  card_counts.values.sum
end

actual = File.read("./day4.txt").lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

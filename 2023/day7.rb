def compare(a, a_type, b, b_type, cards)
  return 1 if a_type > b_type
  return -1 if b_type > a_type
  (0..4).each do |idx|
    return 1 if cards.index(a[0][idx]) < cards.index(b[0][idx])
    return -1 if cards.index(b[0][idx]) < cards.index(a[0][idx])
  end
  return 0
end

def get_type1(hand)
  tally = hand.tally.values
  tally.include?(5) ? 6 : tally.include?(4) ? 5 : (tally.include?(3) && tally.include?(2)) ? 4 : tally.include?(3) ? 3 : tally.tally[2] == 2 ? 2 : tally.include?(2) ? 1 : 0
end

@cards = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

def part1(input)
  hands = input.map { |line|
    hand, bid = line.split(" ")
    [hand.chars, bid.to_i]
  }

  hands.sort! { |a, b|
    a_type = get_type1(a[0])
    b_type = get_type1(b[0])
    compare(a, a_type, b, b_type, @cards)
  }

  hands.map.with_index { |h, i| h[1] * (i + 1) }.sum
end

def get_type2(hand)
  tally = hand.tally
  j_count = tally["J"] || 0
  no_jokers_tally = tally.select { |e| e[0] != "J" }
  counts = no_jokers_tally.values
  return 6 if counts.include?(5) || counts.map { |c| c + j_count }.include?(5) || j_count == 5
  return 5 if counts.include?(4) || counts.map { |c| c + j_count }.include?(4)
  return 4 if (counts.include?(3) && counts.include?(2)) || (j_count == 1 && counts.tally[2] == 2)
  return 3 if counts.include?(3) || counts.map { |c| c + j_count }.include?(3)
  return 2 if counts.tally[2] == 2 || (counts.include?(2) && j_count == 1)
  return 1 if counts.include?(2) || counts.map { |c| c + j_count }.include?(2)
  return 0
end

@cards2 = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

def part2(input)
  hands = input.map { |line|
    hand, bid = line.split(" ")
    [hand.chars, bid.to_i]
  }

  hands.sort! { |a, b|
    a_type = get_type2(a[0])
    b_type = get_type2(b[0])
    compare(a, a_type, b, b_type, @cards2)
  }

  hands.map.with_index { |h, i| h[1] * (i + 1) }.sum
end

actual = File.read("./day7.txt").lines

puts part1(actual)
puts part2(actual)

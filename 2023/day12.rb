def check(row, combination, answer)
  combination.each { |loc| row[loc] = "#" }
  blah = row.join("").gsub("?", ".")
  thing = answer.map { |g| "\#{#{g}}" }.join(".+")
  return blah.match(Regexp.new(thing))
end

def part1(input)
  springs = []
  input.each do |line|
    first, second = line.split(" ")
    chars = first.chars
    groups = second.split(",").map(&:to_i)
    unknowns = []
    broken_count = 0
    chars.each.with_index do |c, i|
      unknowns << i if c == "?"
      broken_count += 1 if c == "#"
    end
    springs << [chars, broken_count, unknowns, groups]
  end

  springs.map { |chars, broken_count, unknowns, groups|
    valid = 0
    unknowns.combination(groups.sum - broken_count).each do |combo|
      valid += 1 if check(chars.clone, combo, groups)
    end
    valid
  }.sum
end

@cache = {}

def find_valid_configurations(map, groups, known_count, unknown_count)
  if groups.sum - known_count == unknown_count
    regex = groups.map { |g| "\#{#{g}}" }.join(".+")
    return map.join("").gsub("?", "#").match(/#{regex}/) ? 1 : 0
  end

  # check if done
  if unknown_count == 0 || known_count == groups.sum
    regex = groups.map { |g| "\#{#{g}}" }.join(".+")
    return map.join("").gsub("?", ".").match(/#{regex}/) ? 1 : 0
  end

  # check if assigned too many
  return 0 if map.tally["?"] < unknown_count

  next_slot = map.index("?")

  # check if breaks  pattern
  if next_slot != 0
    found_groups = []
    closed = 0
    current_group = 0
    map[0, next_slot].each do |c|
      case c
      when "#"
        current_group += 1
      when "."
        if current_group > 0
          found_groups << current_group
          closed += 1
          current_group = 0
        end
      end
    end
    found_groups << current_group if current_group > 0

    found_groups.each.with_index { |g, i|
      return 0 if (i < closed && g != groups[i]) || g > groups[i]
    }
  end

  if @cache.include?([map[next_slot - 1..-1], found_groups, known_count, unknown_count])
    return @cache[[map[next_slot - 1..-1], found_groups, known_count, unknown_count]]
  end

  # go #
  pound = map.clone()
  pound[next_slot] = "#"
  pound_result = find_valid_configurations(pound, groups, known_count + 1, unknown_count - 1)

  # go .
  period = map.clone()
  period[next_slot] = "."
  period_result = find_valid_configurations(period, groups, known_count, unknown_count - 1)

  @cache[[map[next_slot - 1..-1], found_groups, known_count, unknown_count]] = pound_result + period_result

  pound_result + period_result
end

def part2(input)
  input.map { |line|
    @cache = {}
    first, second = line.split(" ")
    first = Array.new(5, first).join("?")
    second = Array.new(5, second).join(",")
    groups = second.split(",").map(&:to_i)
    known_count = first.chars.select { |c| c == "#" }.size
    unknown_count = first.chars.tally["?"]
    valid_configs = find_valid_configurations(first.chars, groups, known_count, unknown_count)
    valid_configs
  }.sum
end

actual = File.read("./day12.txt").lines

puts part1(actual)
puts part2(actual)

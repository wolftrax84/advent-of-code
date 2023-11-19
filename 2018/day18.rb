def getNeighbors(map, loc)
  neighbors = [
    map[[loc[0] - 1, loc[1] - 1]],
    map[[loc[0] - 1, loc[1]]],
    map[[loc[0] - 1, loc[1] + 1]],
    map[[loc[0], loc[1] - 1]],
    map[[loc[0], loc[1] + 1]],
    map[[loc[0] + 1, loc[1] - 1]],
    map[[loc[0] + 1, loc[1]]],
    map[[loc[0] + 1, loc[1] + 1]],
  ]
  return neighbors.tally
end

def print_map(map)
  line = ""
  50.times.with_index do |x|
    50.times.with_index do |y|
      line << map[[x, y]]
    end
  end
  return line
end

def part1(input)
  map = Hash.new { |hash, key| hash[key] = "" }
  input.each.with_index do |line, y|
    line.chars.each.with_index do |c, x|
      map[[x, y]] = c
    end
  end
  10.times do
    next_map = Hash.new
    input.size.times.with_index do |i|
      input[0].size.times.with_index do |j|
        neighbors = getNeighbors(map, [i, j])
        case map[[i, j]]
        when "."
          next_map[[i, j]] = neighbors.include?("|") && neighbors["|"] >= 3 ? "|" : "."
        when "|"
          next_map[[i, j]] = neighbors.include?("#") && neighbors["#"] >= 3 ? "#" : "|"
        when "#"
          next_map[[i, j]] = neighbors.include?("|") && neighbors.include?("#") && neighbors["|"] >= 1 && neighbors["#"] >= 1 ? "#" : "."
        end
      end
    end
    map = next_map
  end
  tally = map.values.tally
  return tally["#"] * tally["|"]
end

def part2(input)
  maps = Set.new
  map = Hash.new { |hash, key| hash[key] = "" }
  input.each.with_index do |line, y|
    line.chars.each.with_index do |c, x|
      map[[x, y]] = c
    end
  end
  map_dict = [map]
  maps << print_map(map)
  found_loop = []
  1000000000.times.with_index do |index|
    next_map = Hash.new
    input.size.times.with_index do |i|
      input[0].size.times.with_index do |j|
        neighbors = getNeighbors(map, [i, j])
        case map[[i, j]]
        when "."
          next_map[[i, j]] = neighbors.include?("|") && neighbors["|"] >= 3 ? "|" : "."
        when "|"
          next_map[[i, j]] = neighbors.include?("#") && neighbors["#"] >= 3 ? "#" : "|"
        when "#"
          next_map[[i, j]] = neighbors.include?("|") && neighbors.include?("#") && neighbors["|"] >= 1 && neighbors["#"] >= 1 ? "#" : "."
        end
      end
    end
    next_map_string = print_map(next_map)
    if maps.include?(next_map_string)
      found_index = map_dict.index(next_map_string)
      found_loop = [found_index, index + 1]
      break
    end
    maps << next_map_string
    map_dict << next_map_string
    map = next_map
  end
  offset = (1000000000 - (found_loop[1])) % (found_loop[1] - found_loop[0])
  tally = map_dict[found_loop[0] + offset].chars.tally
  return tally["#"] * tally["|"]
end

actual = File.read("./day18.txt")

puts part1(actual.lines.map(&:chomp))
puts part2(actual.lines.map(&:chomp))

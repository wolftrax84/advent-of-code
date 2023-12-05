def part1(input)
  seeds = input.shift.scan(/\d+/).map(&:to_i)
  maps = []
  input.each do |map_group|
    parsed_map_group = []
    map_group.split(":\n")[1].lines.each do |map_line|
      parsed_map_group << map_line.scan(/\d+/).map(&:to_i)
    end
    maps << parsed_map_group
  end
  locations = []
  seeds.each do |seed|
    current_value = seed
    maps.each do |map|
      map.each do |map_set|
        if current_value >= map_set[1] && current_value < map_set[1] + map_set[2]
          current_value = map_set[0] + (current_value - map_set[1])
          break
        end
      end
    end
    locations << current_value
  end
  return locations.min
end

def get_ranges(range, map)
  return [range] if range[1] < map[0][1]
  ranges = []
  cursor = range[0]
  map.each do |map_range|
    if cursor < map_range[1]
      ranges << [cursor, map_range[1] - 1]
      cursor = map_range[1]
    end
    if cursor >= map_range[1] && cursor < map_range[1] + map_range[2]
      range_end = [map_range[1] + map_range[2] - 1, range[1]].min
      ranges << [cursor - map_range[1] + map_range[0], range_end - map_range[1] + map_range[0]]
      cursor = range_end + 1
    end
    break if cursor > range[1]
  end
  ranges << [cursor, range[1]] if cursor < range[1]
  ranges
end

def part2(input)
  seeds = input.shift.scan(/\d+/).map(&:to_i).each_slice(2).map { |slice| [slice[0], slice[0] + slice[1] - 1] }
  maps = []
  input.each do |map_group|
    parsed_map_group = []
    map_group.split(":\n")[1].lines.each do |map_line|
      parsed_map_group << map_line.scan(/\d+/).map(&:to_i)
    end
    parsed_map_group.sort_by! { |e| e[1] }
    maps << parsed_map_group
  end
  ranges = seeds
  maps.each.with_index do |map, i|
    next_ranges = []
    ranges.each do |range|
      next_ranges.concat(get_ranges(range, map))
    end
    ranges = next_ranges
  end
  ranges.sort_by! { |r| r[0] }[0][0]
end

actual = File.read("./day5.txt").split("\n\n")

puts part1(actual.clone)
puts part2(actual.clone)

def find_path(map, starting_point)
  path = [starting_point]
  visited = Set.new
  current_point = starting_point
  loop do
    visited << current_point
    path << current_point
    x, y = current_point
    up = [x - 1, y]
    down = [x + 1, y]
    left = [x, y - 1]
    right = [x, y + 1]

    next_points = case map[current_point]
      when "|"
        [up, down]
      when "-"
        [right, left]
      when "F"
        [down, right]
      when "7"
        [left, down]
      when "J"
        [up, left]
      when "L"
        [up, right]
      when "S"
        [up, right, down, left]
      end

    next_points.each do |next_point|
      return path if next_point == starting_point
      if map.include?(next_point) && !visited.include?(next_point)
        current_point = next_point
        break
      end
    end
  end
  path
end

def part1(input)
  map = {}
  starting_point = []
  input.each.with_index do |line, row|
    line.chomp.chars.each.with_index do |c, column|
      starting_point = [row, column] if c == "S"
      map[[row, column]] = c if c != "."
    end
  end

  (find_path(map, starting_point).size / 2).floor()
end

def part2(input)
  map = {}
  starting_point = []
  input.each.with_index do |line, row|
    line.chomp.chars.each.with_index do |c, column|
      starting_point = [row, column] if c == "S"
      map[[row, column]] = c if c != "."
    end
  end

  path = find_path(map, starting_point)
  path_set = Set.new(path)
  min_x, max_x = path.map { |point| point[0] }.minmax
  min_y, max_y = path.map { |point| point[1] }.minmax

  contained_points = Set.new
  path_dirs = []
  current_direction = 0
  path.each.with_index do |node, index|
    next if index == 0
    node_up = [node[0] - 1, node[1]]
    node_down = [node[0] + 1, node[1]]
    node_left = [node[0], node[1] - 1]
    node_right = [node[0], node[1] + 1]

    current_direction = node[0] > path[index - 1][0] ? "down" : node[0] < path[index - 1][0] ? "up" : node[1] < path[index - 1][1] ? "left" : "right"

    points_to_check = []
    case map[node]
    when "F"
      points_to_check = [node_up, node_left] if current_direction == "left"
    when "7"
      points_to_check = [node_up, node_right] if current_direction == "up"
    when "J"
      points_to_check = [node_right, node_down] if current_direction == "right"
    when "L"
      points_to_check = [node_down, node_left] if current_direction == "down"
    when "|"
      points_to_check = [node_right] if current_direction == "up"
      points_to_check = [node_left] if current_direction == "down"
    when "-"
      points_to_check = [node_up] if current_direction == "left"
      points_to_check = [node_down] if current_direction == "right"
    end

    loop do
      break if points_to_check.size == 0
      current_point = points_to_check.shift
      next if path_set.include?(current_point)
      contained_points << current_point
      up = [current_point[0] - 1, current_point[1]]
      down = [current_point[0] + 1, current_point[1]]
      left = [current_point[0], current_point[1] - 1]
      right = [current_point[0], current_point[1] + 1]
      points_to_check << up if !contained_points.include?(up) && !path_set.include?(up) && !points_to_check.include?(up) && up[0] >= min_x
      points_to_check << right if !contained_points.include?(right) && !path_set.include?(right) && !points_to_check.include?(right) && right[1] <= max_y
      points_to_check << down if !contained_points.include?(down) && !path_set.include?(down) && !points_to_check.include?(down) && down[0] <= max_x
      points_to_check << left if !contained_points.include?(left) && !path_set.include?(left) && !points_to_check.include?(left) && left[1] >= min_y
    end
  end

  contained_points.size
end

actual = File.read("./day10.txt").lines

puts part1(actual)
puts part2(actual)

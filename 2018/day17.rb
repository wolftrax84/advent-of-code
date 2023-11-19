def dropWater(loc, dir)
  return [[loc], false] if loc[1] + 1 > @y_limits[1]

  if dir == "down" && !$blah.include?([loc[0], loc[1] + 1]) && $blah2.include?([loc[0], loc[1] + 1])
    $blah2 << loc
    return [[loc], false]
  end

  if !$blah.include?([loc[0], loc[1] + 1])
    points, is_pond = dropWater([loc[0], loc[1] + 1], "down")
    $blah2 << loc
    if is_pond
      points.each do |point|
        $blah << point
      end
    end
    return [[*points, loc], false] if !is_pond
  end

  left_points = []
  left_is_pond = true
  right_points = []
  right_is_pond = true

  if dir != "left" && !$blah.include?([loc[0] - 1, loc[1]])
    left_points, left_is_pond = dropWater([loc[0] - 1, loc[1]], "right") if dir != "left"
  end
  if dir != "right" && !$blah.include?([loc[0] + 1, loc[1]])
    right_points, right_is_pond = dropWater([loc[0] + 1, loc[1]], "left") if dir != "right"
  end

  $blah2 << loc
  return [[*points, *left_points, *right_points, loc], left_is_pond && right_is_pond]
end

@y_limits = [Float::INFINITY, 0]
$blah = Set.new
$blah2 = Set.new

def part1(input)
  $blah = Set.new
  $blah2 = Set.new
  @y_limits = [Float::INFINITY, 0]
  input.each do |line|
    _, first, first_value, second, second_range_start, second_range_end = line.match(/(x|y)=(\d+), (x|y)=(\d+)..(\d+)/).to_a
    first_value = first_value.to_i
    second_range_start = second_range_start.to_i
    second_range_end = second_range_end.to_i
    if first == "x"
      @y_limits[0] = second_range_start if second_range_start < @y_limits[0]
      @y_limits[1] = second_range_end if second_range_end > @y_limits[1]
    else
      @y_limits[0] = first_value if first_value < @y_limits[0]
      @y_limits[1] = first_value if first_value > @y_limits[1]
    end
    (second_range_start..second_range_end).each do |range_value|
      $blah << [first == "x" ? first_value : range_value, second == "x" ? first_value : range_value]
    end
  end
  results, whatever = dropWater([500, @y_limits[0] - 1], "down")
  return results.size - 1
end

def part2(input)
  $blah = Set.new
  $blah2 = Set.new
  @y_limits = [Float::INFINITY, 0]
  input.each do |line|
    _, first, first_value, second, second_range_start, second_range_end = line.match(/(x|y)=(\d+), (x|y)=(\d+)..(\d+)/).to_a
    first_value = first_value.to_i
    second_range_start = second_range_start.to_i
    second_range_end = second_range_end.to_i
    if first == "x"
      @y_limits[0] = second_range_start if second_range_start < @y_limits[0]
      @y_limits[1] = second_range_end if second_range_end > @y_limits[1]
    else
      @y_limits[0] = first_value if first_value < @y_limits[0]
      @y_limits[1] = first_value if first_value > @y_limits[1]
    end
    (second_range_start..second_range_end).each do |range_value|
      $blah << [first == "x" ? first_value : range_value, second == "x" ? first_value : range_value]
    end
  end
  results, whatever = dropWater([500, @y_limits[0] - 1], "down")
  return ($blah & $blah2).size
end

actual = File.read("./day17.txt")

puts part1(actual.lines.map(&:chomp))
puts part2(actual.lines.map(&:chomp))

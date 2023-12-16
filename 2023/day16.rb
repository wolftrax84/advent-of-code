def get_energized_count(objects, start, size)
  energized_cells = Hash.new { |h, k| h[k] = Set.new }
  beams = [start]
  loop do
    break if beams.empty?
    beam = beams.shift
    case beam[2]
    when 0
      if beam[0] == 0
        next
      end
      up = [beam[0] - 1, beam[1]]
      if !objects.include?(up) && !energized_cells[up].include?(0)
        beams << [*up, 0]
        energized_cells[up] << 0
        next
      end
      case objects[up]
      when "|"
        if !energized_cells[up].include?(0)
          beams << [*up, 0]
          energized_cells[up] << 0
        end
      when "/"
        if !energized_cells[up].include?(1)
          beams << [*up, 1]
          energized_cells[up] << 1
        end
      when "\\"
        if !energized_cells[up].include?(3)
          beams << [*up, 3]
          energized_cells[up] << 3
        end
      when "-"
        if !energized_cells[up].include?(1)
          beams << [*up, 1]
          energized_cells[up] << 1
        end
        if !energized_cells[up].include?(3)
          beams << [*up, 3]
          energized_cells[up] << 3
        end
      end
    when 1
      if beam[1] + 1 == size
        next
      end
      right = [beam[0], beam[1] + 1]
      if !objects.include?(right) && !energized_cells[right].include?(1)
        beams << [*right, 1]
        energized_cells[right] << 1
        next
      end
      case objects[right]
      when "|"
        if !energized_cells[right].include?(0)
          beams << [*right, 0]
          energized_cells[right] << 0
        end
        if !energized_cells[right].include?(2)
          beams << [*right, 2]
          energized_cells[right] << 2
        end
      when "/"
        if !energized_cells[right].include?(0)
          beams << [*right, 0]
          energized_cells[right] << 0
        end
      when "\\"
        if !energized_cells[right].include?(2)
          beams << [*right, 2]
          energized_cells[right] << 2
        end
      when "-"
        if !energized_cells[right].include?(1)
          beams << [*right, 1]
          energized_cells[right] << 1
        end
      end
    when 2
      if beam[0] + 1 == size
        next
      end
      down = [beam[0] + 1, beam[1]]
      if !objects.include?(down) && !energized_cells[down].include?(2)
        beams << [*down, 2]
        energized_cells[down] << 2
        next
      end
      case objects[down]
      when "|"
        if !energized_cells[down].include?(2)
          beams << [*down, 2]
          energized_cells[down] << 2
        end
      when "/"
        if !energized_cells[down].include?(3)
          beams << [*down, 3]
          energized_cells[down] << 3
        end
      when "\\"
        if !energized_cells[down].include?(1)
          beams << [*down, 1]
          energized_cells[down] << 1
        end
      when "-"
        if !energized_cells[down].include?(1)
          beams << [*down, 1]
          energized_cells[down] << 1
        end
        if !energized_cells[down].include?(3)
          beams << [*down, 3]
          energized_cells[down] << 3
        end
      end
    when 3
      if beam[1] == 0
        next
      end
      left = [beam[0], beam[1] - 1]
      if !objects.include?(left) && !energized_cells[left].include?(3)
        beams << [*left, 3]
        energized_cells[left] << 3
        next
      end
      case objects[left]
      when "|"
        if !energized_cells[left].include?(0)
          beams << [*left, 0]
          energized_cells[left] << 0
        end
        if !energized_cells[left].include?(2)
          beams << [*left, 2]
          energized_cells[left] << 2
        end
      when "/"
        if !energized_cells[left].include?(2)
          beams << [*left, 2]
          energized_cells[left] << 2
        end
      when "\\"
        if !energized_cells[left].include?(0)
          beams << [*left, 0]
          energized_cells[left] << 0
        end
      when "-"
        if !energized_cells[left].include?(3)
          beams << [*left, 3]
          energized_cells[left] << 3
        end
      end
    end
  end
  energized_cells.select { |k, v| v.size > 0 }.size
end

def part1(input)
  objects = {}
  input.each.with_index do |line, row|
    line.chars.each.with_index do |c, col|
      case c
      when "."
        next
      else
        objects[[row, col]] = c
      end
    end
  end

  get_energized_count(objects, [0, -1, 1], input.size)
end

def part2(input)
  objects = {}
  input.each.with_index do |line, row|
    line.chars.each.with_index do |c, col|
      case c
      when "."
        next
      else
        objects[[row, col]] = c
      end
    end
  end

  (0..input.size).map { |i|
    results = []
    results << get_energized_count(objects, [-1, i, 2], input.size)
    results << get_energized_count(objects, [input.size, i, 0], input.size)
    results << get_energized_count(objects, [i, -1, 1], input.size)
    results << get_energized_count(objects, [i, input.size, 3], input.size)
    results.max
  }.max
end

actual = File.read("./day16.txt").lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

def tilt_north(cols)
  cols.map { |col|
    last_block = -1
    new_col = []
    col.each.with_index do |c, i|
      case c
      when "#"
        new_col << c
        last_block = i
      when "."
        new_col << c
        next
      when "O"
        if last_block + 1 == i
          last_block = i
          new_col << c
        else
          new_col[last_block + 1] = c
          last_block += 1
          new_col << "."
        end
      end
    end
    new_col
  }
end

def tilt_west(cols)
  rows = (0...cols.size).map { |i| cols.map { |c| c[i] } }.map { |row|
    last_block = -1
    new_row = []
    row.each.with_index do |c, i|
      case c
      when "#"
        new_row << c
        last_block = i
      when "."
        new_row << c
        next
      when "O"
        if last_block + 1 == i
          last_block = i
          new_row << c
        else
          new_row[last_block + 1] = c
          last_block += 1
          new_row << "."
        end
      end
    end
    new_row
  }
  (0...rows.size).map { |i| rows.map { |r| r[i] } }
end

def tilt_south(cols)
  cols.map { |col|
    last_block = -1
    new_col = []
    col.reverse.each.with_index do |c, i|
      case c
      when "#"
        new_col << c
        last_block = i
      when "."
        new_col << c
        next
      when "O"
        if last_block + 1 == i
          last_block = i
          new_col << c
        else
          new_col[last_block + 1] = c
          last_block += 1
          new_col << "."
        end
      end
    end
    new_col.reverse
  }
end

def tilt_east(cols)
  rows = (0...cols.size).map { |i| cols.map { |c| c[i] } }.map { |row|
    last_block = -1
    new_row = []
    row.reverse.each.with_index do |c, i|
      case c
      when "#"
        new_row << c
        last_block = i
      when "."
        new_row << c
        next
      when "O"
        if last_block + 1 == i
          last_block = i
          new_row << c
        else
          new_row[last_block + 1] = c
          last_block += 1
          new_row << "."
        end
      end
    end
    new_row.reverse
  }
  (0...rows.size).map { |i| rows.map { |r| r[i] } }
end

def part1(input)
  cols = Array.new(input[0].chomp.size) { [] }
  input.each do |line|
    line.chomp.chars.each.with_index do |c, i|
      cols[i] << c
    end
  end

  result = tilt_north(cols)
  result.map { |col| col.map.with_index { |c, i| c == "O" ? (cols[0].size - i) : 0 }.sum }.sum
end

def get_cache_key(cols)
  cycle_set = Set.new
  cols.each.with_index do |col, j|
    col.each.with_index do |char, i|
      cycle_set << [i, j] if char == "O"
    end
  end
  cycle_set
end

def run_cycle(cols)
  tilt_east(tilt_south(tilt_west(tilt_north(cols))))
end

def part2(input)
  cache = {}
  cols = Array.new(input[0].size) { [] }
  input.each do |line|
    line.chars.each.with_index do |c, i|
      cols[i] << c
    end
  end
  cache[get_cache_key(cols)] = [0, 0, 1]
  found_loop = 0
  loop_start = nil
  cycle_result = nil
  iteration = 0
  1000000000.times do
    cycle_result = run_cycle(cycle_result || cols)
    cache_key = cycle_result.flatten
    iteration += 1
    if cache.include?(cache_key)
      if cache[cache_key][2] > 1
        found_loop = cache[cache_key]
        break
      elsif cache[cache_key][2] == 1
        cache[cache_key][1] = iteration - cache[cache_key][0]
        cache[cache_key][2] += 1
      else
        cache[cache_key][2] += 1
      end
    else
      cache[cache_key] = [iteration, 0, 1]
    end
  end

  result = nil
  (((1000000000 - found_loop[0]) % (found_loop[1])) + found_loop[0]).times do
    result = run_cycle(result || cols)
  end
  result.map { |col| col.map.with_index { |c, i| c == "O" ? (cols[0].size - i) : 0 }.sum }.sum
end

actual = File.read("./day14.txt").lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

def next_to_symbol(id, symbols)
  (-1..id[0].size).each do |col|
    (-1..1).each do |row|
      return id[0].to_i if symbols.include?([id[1][0] + row, id[1][1] + col])
    end
  end
  return 0
end

def part1(input)
  ids = []
  symbols = Set.new
  input.each.with_index do |line, row|
    current_id = ""
    current_id_col = 0
    line.chars.each.with_index do |char, column|
      if char == "."
        ids << [current_id, [row, current_id_col]] if current_id != ""
        current_id = ""
        next
      elsif char.to_i.to_s == char && char != "-"
        current_id_col = column if current_id == ""
        current_id << char
      else
        symbols << [row, column]
        ids << [current_id, [row, current_id_col]] if current_id != ""
        current_id = ""
      end
    end
    ids << [current_id, [row, current_id_col]] if current_id != ""
  end
  return ids.map { |id| next_to_symbol(id, symbols) }.sum
end

def part_of_gear(id, symbols)
  (-1..id[0].size).each do |col|
    (-1..1).each do |row|
      loc = [id[1][0] + row, id[1][1] + col]
      if symbols.include?(loc)
        symbols[loc] << id[0]
        break
      end
    end
  end
end

def part2(input)
  ids = []
  symbols = {}
  input.each.with_index do |line, row|
    current_id = ""
    current_id_col = 0
    line.chars.each.with_index do |char, column|
      if char == "."
        ids << [current_id, [row, current_id_col]] if current_id != ""
        current_id = ""
        next
      elsif char.to_i.to_s == char && char != "-"
        current_id_col = column if current_id == ""
        current_id << char
      elsif char == "*"
        symbols[[row, column]] = []
        ids << [current_id, [row, current_id_col]] if current_id != ""
        current_id = ""
      end
    end
    ids << [current_id, [row, current_id_col]] if current_id != ""
  end
  ids.each { |id| part_of_gear(id, symbols) }
  return symbols.values.select { |val| val.size == 2 }.map { |gear| gear.map(&:to_i).reduce(:*) }.sum
end

actual = File.read("./day3.txt").lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

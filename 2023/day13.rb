def part1(input)
  boards = input.split("\n\n").map(&:chomp).map(&:lines)
  boards.map { |board|
    rows = []
    cols = Array.new(board[0].chomp.size) { [] }
    board.each do |line|
      rows << line.chomp.gsub(".", "0").gsub("#", "1").to_i(2)
      line.chomp.chars.each.with_index { |c, i|
        cols[i] << c
      }
    end
    cols.map! { |c| c.join("").gsub(".", "0").gsub("#", "1").to_i(2) }

    v_reflection = nil
    h_reflection = nil

    (0...cols.size).each_cons(2) do |pair|
      next if cols[pair[0]] != cols[pair[1]]
      l = pair[0] - 1
      r = pair[1] + 1
      loop do
        if l < 0 || r == cols.size
          v_reflection = pair
          break
        end
        break if cols[l] != cols[r]
        l -= 1
        r += 1
      end
    end
    (0...rows.size).each_cons(2) do |pair|
      next if rows[pair[0]] != rows[pair[1]]
      u = pair[0] - 1
      d = pair[1] + 1
      loop do
        if u < 0 || d == rows.size
          h_reflection = pair
          break
        end
        break if rows[u] != rows[d]
        u -= 1
        d += 1
      end
    end
    v_reflection ? v_reflection[0] + 1 : (h_reflection[0] + 1) * 100
  }.sum
end

def part2(input)
  boards = input.split("\n\n").map(&:chomp).map(&:lines)
  boards.map.with_index { |board, i|
    rows = []
    cols = Array.new(board[0].chomp.size) { [] }
    board.each do |line|
      rows << line.chomp.gsub(".", "0").gsub("#", "1").to_i(2)
      line.chomp.chars.each.with_index { |c, i|
        cols[i] << c
      }
    end
    cols.map! { |c| c.join("").gsub(".", "0").gsub("#", "1").to_i(2) }

    v_reflection = nil
    h_reflection = nil
    old_v_reflection = nil
    (0...cols.size).each_cons(2) do |pair|
      next if cols[pair[0]] != cols[pair[1]]
      l = pair[0] - 1
      r = pair[1] + 1
      loop do
        if l < 0 || r == cols.size
          old_v_reflection = pair
          break
        end
        break if cols[l] != cols[r]
        l -= 1
        r += 1
      end
    end
    (0...cols.size).each_cons(2) do |pair|
      next if ((cols[pair[0]] ^ cols[pair[1]]).to_s(2).count("1") > 1 || pair == old_v_reflection)
      l = pair[0] - 1
      r = pair[1] + 1
      loop do
        if l < 0 || r == cols.size
          v_reflection = pair
          break
        end
        break if (cols[l] ^ cols[r]).to_s(2).count("1") > 1
        l -= 1
        r += 1
      end
    end
    old_h_reflection = nil
    (0...rows.size).each_cons(2) do |pair|
      next if rows[pair[0]] != rows[pair[1]]
      u = pair[0] - 1
      d = pair[1] + 1
      loop do
        if u < 0 || d == rows.size
          old_h_reflection = pair
          break
        end
        break if rows[u] != rows[d]
        u -= 1
        d += 1
      end
    end
    (0...rows.size).each_cons(2) do |pair|
      next if ((rows[pair[0]] ^ rows[pair[1]]).to_s(2).count("1") > 1 || pair == old_h_reflection)
      u = pair[0] - 1
      d = pair[1] + 1
      loop do
        if u < 0 || d == rows.size
          h_reflection = pair
          break
        end
        break if (rows[u] ^ rows[d]).to_s(2).count("1") > 1
        u -= 1
        d += 1
      end
    end
    v_reflection ? v_reflection[0] + 1 : (h_reflection[0] + 1) * 100
  }.sum
end

actual = File.read("./day13.txt")
# actual = "#.##..##.
# ..#.##.#.
# ##......#
# ##......#
# ..#.##.#.
# ..##..##.
# #.#.##.#.

# #...##..#
# #....#..#
# ..##..###
# #####.##.
# #####.##.
# ..##..###
# #....#..#"

puts part1(actual)
puts part2(actual)
times1 = []
times2 = []
result1 = ""
result2 = ""
100.times do
  actual1 = actual.clone
  actual2 = actual.clone
  starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  result1 = part1(actual1)
  ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  times1 << ending - starting
  starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  result2 = part2(actual2)
  ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  times2 << ending - starting
end
puts "#{result1} | #{(times1.sum / 100 * 1000).round(2)} ms"
puts "#{result2} | #{(times2.sum / 100 * 1000).round(2)} ms"

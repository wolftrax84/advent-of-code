def part1(input)
  times = input[0].scan(/\d+/).map(&:to_i)
  records = input[1].scan(/\d+/).map(&:to_i)

  ways_to_win = []
  times.each.with_index do |race_time, index|
    start = (0..race_time).bsearch { |e| e * (race_time - e) > records[index] }
    ending = (start..race_time).bsearch { |e| e * (race_time - e) < records[index] }
    ways_to_win << ending - start
  end
  return ways_to_win.inject(:*)
end

def part2(input)
  time = input[0].scan(/\d+/).join("").to_i
  record = input[1].scan(/\d+/).join("").to_i

  start = (0..time).bsearch { |e| e * (time - e) > record }
  ending = (start..time).bsearch { |e| e * (time - e) < record }
  return ending - start
end

actual = File.read("./day6.txt").lines

puts part1(actual)
puts part2(actual)

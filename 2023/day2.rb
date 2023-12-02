def part1(input)
  good_games = 0
  input.each do |line|
    game_number, game = line.split(":")
    pulls = game.split(";").map(&:chomp)
    matches = pulls.map { |pull| pull.scan(/(\d+)\s(blue|red|green)/) }.flatten
    pairs = matches.each_cons(2).to_a.select.with_index { |p, i| i % 2 == 0 }
    bad_game = false
    pairs.each do |pair|
      case pair[1]
      when "green"
        if pair[0].to_i > 13
          bad_game = true
          break
        end
      when "red"
        if pair[0].to_i > 12
          bad_game = true
          break
        end
      when "blue"
        if pair[0].to_i > 14
          bad_game = true
          break
        end
      end
    end
    good_games += game_number.split(" ")[1].to_i if !bad_game
  end
  return good_games
end

def part2(input)
  power = 0
  input.each do |line|
    game = line.split(":")[1]
    pulls = game.split(";").map(&:chomp)
    matches = pulls.map { |pull| pull.scan(/(\d+)\s(blue|red|green)/) }.flatten
    pairs = matches.each_cons(2).to_a.select.with_index { |p, i| i % 2 == 0 }
    mins = [0, 0, 0]
    pairs.each do |pair|
      case pair[1]
      when "green"
        if pair[0].to_i > mins[0]
          mins[0] = pair[0].to_i
        end
      when "red"
        if pair[0].to_i > mins[1]
          mins[1] = pair[0].to_i
        end
      when "blue"
        if pair[0].to_i > mins[2]
          mins[2] = pair[0].to_i
        end
      end
    end
    power += mins.inject(:*)
  end
  return power
end

actual = File.read("./day2.txt").lines

puts part1(actual)
puts part2(actual)

def part1(input)
    player_count, marble_count = input
    chain = [0]
    current_player = 1
    current_marble = 0
    scores = Hash.new(0)
    marble_count.times do |i|
        next if i == 0
        if i%23 == 0
            scores[current_player] += i
            marble_to_remove_index = (current_marble - 7)%chain.count
            scores[current_player] += chain.delete_at(marble_to_remove_index)
            current_marble = marble_to_remove_index
        else
            insert = (current_marble + 2) % chain.count
            chain.insert(insert,i)
            current_marble = insert
        end
        current_player = current_player == player_count ? 1 : current_player + 1
    end
    scores.max_by{|k,v| v}.last
end

class Link
    def initialize value
      @value = value
    end
    attr_reader :value
    attr_accessor :counter_clockwise, :clockwise
end

def part2(input)
    player_count, marble_count = input
    marble_count *= 100
    scores = Hash.new(0)
    current_player = 1
    current_marble = Link.new(0)
    current_marble.counter_clockwise = current_marble
    current_marble.clockwise = current_marble
    (1..marble_count).each do |i|
        if i%23 == 0
            scores[i%player_count] += i
            current_marble = current_marble.counter_clockwise.counter_clockwise.counter_clockwise.counter_clockwise.counter_clockwise.counter_clockwise.counter_clockwise
            scores[i%player_count] += current_marble.value
            current_marble.counter_clockwise.clockwise = current_marble.clockwise
            current_marble.clockwise.counter_clockwise = current_marble.counter_clockwise
            current_marble = current_marble.clockwise
        else
            current_marble = current_marble.clockwise
            new_marble = Link.new(i)
            new_marble.clockwise = current_marble.clockwise
            new_marble.counter_clockwise = current_marble
            current_marble.clockwise = new_marble
            new_marble.clockwise.counter_clockwise = new_marble
            current_marble = new_marble
        end
    end
    scores.max_by{|k,v| v}.last
end

actual = [404, 71852]

puts part1(actual)
puts part2(actual)

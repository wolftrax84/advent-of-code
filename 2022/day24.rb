require "fc"

def part1(input)
    blizzards = [Hash.new{|h,k| h[k] = []}, Hash.new{|h,k| h[k] = []}, Hash.new{|h,k| h[k] = []}, Hash.new{|h,k| h[k] = []}]
    current = [0,1]
    input.each.with_index do |l,i|
        l.chomp.chars.each.with_index do |c,j|
            next if c == "." || c == "#"
            case c
            when "^"
                blizzards[0][j] << i
            when ">"
                blizzards[1][i] << j
            when "v"
                blizzards[2][j] << i
            when "<"
                blizzards[3][i] << j
            end
        end
    end
    max_width = input[0].chomp.chars.count - 1
    max_height = input.count - 1
    loaded_states = {}
    states = FastContainers::PriorityQueue.new(:min) 
    states.push([[0,1],0],0)
    states.push([[0,1],1],1)
    time_to_end = 0
    loop do
        location, time = states.pop
        return time if location == [max_height, max_width-1]
        possible_next_locations = [[location[0]-1, location[1]], [location[0],location[1]-1], [location[0],location[1]+1], [location[0]+1, location[1]], location]
        next_locations = possible_next_locations.select { |possible| 
            next if possible[0] <= 0 || (possible[0] == max_height && possible[1] != max_width-1) || possible[1] <= 0 || possible[1] == max_width
            results = []
            results << blizzards[0][possible[1]].any? {|l| ((((l-1)-(time+1)) % (max_height-1))+1) == possible[0]}
            results << blizzards[1][possible[0]].any? {|l| (((l+(time+1)-1) % (max_width-1))+1) == possible[1]}
            results << blizzards[2][possible[1]].any? {|l| (((l+(time+1)-1) % (max_height-1))+1) == possible[0]}
            results << blizzards[3][possible[0]].any? {|l| ((((l-1)-(time+1)) % (max_width-1))+1) == possible[1]}
            results.none?
        }
        next_locations.each do |next_loc|
            prio_key = "#{(time+1)}|#{next_loc[1]}|#{next_loc[0]}"
            next if loaded_states.has_key?(prio_key)
            loaded_states[prio_key] = true
            states.push([next_loc,time+1], time+1)
        end
    end
end

def part2(input)
    blizzards = [Hash.new{|h,k| h[k] = []}, Hash.new{|h,k| h[k] = []}, Hash.new{|h,k| h[k] = []}, Hash.new{|h,k| h[k] = []}]
    current = [0,1]
    input.each.with_index do |l,i|
        l.chomp.chars.each.with_index do |c,j|
            next if c == "." || c == "#"
            case c
            when "^"
                blizzards[0][j] << i
            when ">"
                blizzards[1][i] << j
            when "v"
                blizzards[2][j] << i
            when "<"
                blizzards[3][i] << j
            end
        end
    end
    max_width = input[0].chomp.chars.count - 1
    max_height = input.count - 1
    loaded_states = {}
    states = FastContainers::PriorityQueue.new(:min)
    states.push([[0,1],0],0)
    states.push([[0,1],1],1)
    time_to_end = 0
    start_target = [0,1]
    end_target = [max_height, max_width-1]
    current_target = end_target
    3.times do
        loop do
            location, time = states.pop
            if location == current_target
                states = FastContainers::PriorityQueue.new(:min) 
                states.push([location, time], time)
                time_to_end = time
                current_target = current_target == start_target ? end_target : start_target
                loaded_states = {}
                break
            end
            possible_next_locations = [[location[0]-1, location[1]], [location[0],location[1]-1], [location[0],location[1]+1], [location[0]+1, location[1]], location]
            next_locations = possible_next_locations.select { |possible| 
                next if possible[0] < 0 || (possible[0] == 0 && possible[1] != 1) || (possible[0] == max_height && possible[1] != max_width-1) || possible[1] <= 0 || possible[1] == max_width
                results = []
                results << blizzards[0][possible[1]].any? {|l| ((((l-1)-(time+1)) % (max_height-1))+1) == possible[0]}
                results << blizzards[1][possible[0]].any? {|l| (((l+(time+1)-1) % (max_width-1))+1) == possible[1]}
                results << blizzards[2][possible[1]].any? {|l| (((l+(time+1)-1) % (max_height-1))+1) == possible[0]}
                results << blizzards[3][possible[0]].any? {|l| ((((l-1)-(time+1)) % (max_width-1))+1) == possible[1]}
                results.none?
            }
            next_locations.each do |next_loc|
                prio_key = "#{(time+1)}|#{next_loc[1]}|#{next_loc[0]}"
                next if loaded_states.has_key?(prio_key)
                loaded_states[prio_key] = true
                states.push([next_loc,time+1], time+1)
            end
        end
    end
    time_to_end
end

actual = File.read('./day24.txt').lines

puts part1(actual)
puts part2(actual)

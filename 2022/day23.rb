class Elf
    def initialize location
        @location = location
    end

    attr_accessor :location
    attr_accessor :proposed_location

    def propose_location(elves, dir)
        neighbors = []
        neighbors << (elves.has_key?([@location[0]-1, @location[1]-1]) || elves.has_key?([@location[0]-1, @location[1]]) || elves.has_key?([@location[0]-1, @location[1]+1]))
        neighbors << (elves.has_key?([@location[0]+1, @location[1]-1]) || elves.has_key?([@location[0]+1, @location[1]]) || elves.has_key?([@location[0]+1, @location[1]+1]))
        neighbors << (elves.has_key?([@location[0]-1, @location[1]-1]) || elves.has_key?([@location[0], @location[1]-1]) || elves.has_key?([@location[0]+1, @location[1]-1]))
        neighbors << (elves.has_key?([@location[0]-1, @location[1]+1]) || elves.has_key?([@location[0], @location[1]+1]) || elves.has_key?([@location[0]+1, @location[1]+1]))
        
        return @proposed_location = nil if neighbors.none?
        4.times do
            if !neighbors[dir]
                case dir
                when 0
                    return @proposed_location = [@location[0]-1, @location[1]]
                when 1
                    return @proposed_location = [@location[0]+1, @location[1]]
                when 2
                    return @proposed_location = [@location[0], @location[1] - 1]
                when 3
                    return @proposed_location = [@location[0], @location[1] + 1]
                end
            end
            dir = (dir + 1) % 4
        end
        return @proposed_location = nil
    end

    def move(allowed_moves)
        @location = @proposed_location if allowed_moves.has_key?(@proposed_location)
    end
end

def part1(input)
    elves = {}
    input.each.with_index do |line,row|
        line.chomp.chars.each.with_index do |char, col|
            elves[[row,col]] = Elf.new([row, col]) if char == "#"
        end
    end
    
    10.times.with_index do |i|
        starting_dir = i % 4
        proposed_locations = elves.values.map {|e| e.propose_location(elves, starting_dir)}
        allowed_moves = proposed_locations.tally.select{|k,v| v < 2}#.keys
        elves.values.map {|e| e.move(allowed_moves) if e.proposed_location}
    end
    boundary_width = elves.values.map {|e| e.location[1]}.minmax.reverse.inject(:-)+1
    boundary_height = elves.values.map {|e| e.location[0]}.minmax.reverse.inject(:-)+1
    boundary_height * boundary_width - elves.size
end

def part2(input)
    elves = {}
    input.each.with_index do |line,row|
        line.chomp.chars.each.with_index do |char, col|
            elves[[row,col]] = Elf.new([row, col]) if char == "#"
        end
    end
    i = 0
    loop do
        starting_dir = i % 4
        proposed_locations = elves.values.map {|e| e.propose_location(elves, starting_dir)}
        allowed_moves = proposed_locations.tally.select{|k,v| v < 2}
        return i+1 if allowed_moves.empty?
        elves.values.map {|e| e.move(allowed_moves) if e.proposed_location}
        elves.keys.each do |k|
            next if elves[k].location == k
            elves[elves[k].location] = elves[k]
            elves.delete(k)
        end
        i += 1
    end
end

actual = File.read('./day23.txt').lines

puts part1(actual)
puts part2(actual)

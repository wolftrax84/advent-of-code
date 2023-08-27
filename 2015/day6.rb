def part1(input)
    # Define light map
    lights = Hash.new {|hash,key| hash[key] = Set.new()}

    # Iterate through each instruction
    input.each do |line|
        # Parse instruction
        _, instruction, from_x, from_y, to_x, to_y = line.match(/(turn on |turn off |toggle )(\d+),(\d+) through (\d+),(\d+)/).to_a

        # Loop through each row of the instruction space
        (from_x..to_x).each do |x|
            # Loop through each column of the instruction space 
            (from_y..to_y).each do |y|
                case instruction
                # Add light to row set if turn on instruction
                when "turn on "
                    lights[x].add(y)
                # Remove light from row set if turn off instruction
                when "turn off "
                    lights[x].delete(y)
                # Add light to row set if toggle instruction if not already there, else remove it
                when "toggle "
                    lights[x].include?(y) ? lights[x].delete(y) : lights[x].add(y)
                end
            end
        end        
    end

    # Sum all row set sizes to get total number of lights lit 
    return lights.values.map {|row| row.size}.sum
end

def part2(input)
    # Define light map, initializing each row to an empty hash that will initialize new values to 0
    lights = Hash.new {|hash,key| hash[key] = Hash.new {|hash2, key2| hash2[key2] = 0}}

    # Iterate through each instruction
    input.each do |line|
        # Parse instruction
        _, instruction, from_x, from_y, to_x, to_y = line.match(/(turn on |turn off |toggle )(\d+),(\d+) through (\d+),(\d+)/).to_a

        # Loop through each row of the instruction space
        (from_x..to_x).each do |x|
            # Loop through each column of the instruction space 
            (from_y..to_y).each do |y|
                case instruction
                # Add 1 to light brightness if turn on instruction
                when "turn on "
                    lights[x][y] += 1
                # Subtract 1 from light brightness down to 0 if turn off instruction
                when "turn off "
                    lights[x][y] -= 1 unless lights[x][y] === 0
                # Add 2 to light brightness if toggle instruction
                when "toggle "
                    lights[x][y] += 2
                end
            end
        end        
    end

    # Sum all row's sum of light brightnesses to get total brightness
    return lights.values.map {|row| row.values.sum}.sum
end

actual = File.read("./day6.txt").lines

puts part1(actual)
puts part2(actual)

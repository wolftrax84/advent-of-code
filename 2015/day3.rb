def part1(input)
    # Initialize set for houses visited and starting location
    houses = Set[[0,0]]
    location = [0,0]

    # Iterate through directions and add visited houses to set
    input.chars.each do |c|
        case c
        when '^' 
            location[0] += 1
        when 'v'
            location[0] -= 1
        when '<'
            location[1] -= 1
        when '>'
            location[1] += 1
        end
        houses.add([location[0],location[1]])
    end

    # Return house set size
    return houses.size
end

def part2(input)
    # Initialize set for houses visited
    houses = Set[[0,0]]

    # Set initial location for both santas
    santa_location = [0,0]
    robo_santa_location = [0,0]

    # Iterate through directions and populate house set
    input.chars.each.with_index do |c, index|
        # Set temporary location based on odd or even instruction
        location = index % 2 === 0 ? santa_location : robo_santa_location

        # Update temporary location
        case c
        when '^' 
            location[0] += 1
        when 'v'
            location[0] -= 1
        when '<'
            location[1] -= 1
        when '>'
            location[1] += 1
        end

        # Add new location to houses visited set
        houses.add([location[0],location[1]])

        # Update proper location based on odd or even instruction
        if index % 2 === 0
            santa_location = location
        else
            robo_santa_location = location
        end
    end

    # Return house set size
    return houses.size
end

actual = File.read("./day3.txt").lines.first

puts part1(actual)
puts part2(actual)

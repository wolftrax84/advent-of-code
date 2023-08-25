def part1(input)
    # Calculate number of '(' and ')'
    tally = input.chars.tally

    # Find final floor by subtracting downward movements [')'] from upward movements ['(']
    return tally['('] - tally[')']
end

def part2(input)
    # Set initial floor to 0
    floor = 0

    # Iterate through floor movements
    loop.with_index do |_, i|

        # Update current floor based on movement character
        floor += input[i] === '(' ? 1 : -1

        # Return index (1-indexed) of movement if floor is negative
        return i+1 if floor < 0
    end
end

actual = File.read("./day1.txt").lines.first

puts part1(actual)
puts part2(actual)

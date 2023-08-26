def part1(input)
    # Filter input strings by rules
    nice_strings = input.select do |string|
        # Test rule 1 - at least 3 vowels
        !(string =~ /([aeiou].*){3}/).nil? &&
        # Test rule 2 - double letter
        !(string =~ /(.)\1/).nil? &&
        # Test rule 3 - no special strings
        (string =~ /ab|cd|pq|xy/).nil?
    end
    
    # Return number of filtered strings
    return nice_strings.size
end

def part2(input)
    # Filter input strings by rules
    nice_strings = input.select do |string|
        # Test rule 1 - repeated two character string
        !(string =~ /(..).*\1/).nil? &&
        # Test rule 2 - repeated letter with another character in between
        !(string =~ /(.).{1}\1/).nil?
    end
    
    # Return number of filtered strings
    return nice_strings.size
end

actual = File.read("./day5.txt").lines

puts part1(actual)
puts part2(actual)

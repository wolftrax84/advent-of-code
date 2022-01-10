def part1(input)
    return input.reduce(:+)
end

def part2(input)
    found_freqs = {0 => 1}
    current_freq = 0
    loop do
        input.each do |n|
            current_freq += n
            if found_freqs.has_key?(current_freq)
                return current_freq
            end
            found_freqs[current_freq] = 1
        end
    end
end

actual = File.read("./day1.txt").lines.map(&:to_i)

puts part1(actual)
puts part2(actual)
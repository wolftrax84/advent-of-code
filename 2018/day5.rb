def react(polymer)
    restart = 0
    loop do
        catch :reacted do
            for i in restart...(polymer.count-1)
                if (polymer[i].upcase == polymer[i] && polymer[i].downcase == polymer[i+1])||(polymer[i].downcase == polymer[i] && polymer[i].upcase == polymer[i+1])
                    polymer.slice!(i,2)
                    restart = i-1
                    throw :reacted
                end
            end
            return polymer.count
        end
    end
end

def part1(input)
    polymer = input.chomp.split('')
    react(polymer)
end

def part2(input)
    results = {}
    for letter in 'a'..'z'
        polymer = input.chomp.split('').select {|c| c.downcase != letter}
        results[letter] = react(polymer)
    end
    results.min_by {|k,v| v}[1]
end

actual = File.read('./day5.txt')

puts part1(actual)
puts part2(actual)

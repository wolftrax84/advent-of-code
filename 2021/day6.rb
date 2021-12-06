def part1(input)
    ages = Hash.new(0)
    input.split(",").map(&:to_i).each { |x| ages[x] += 1 }
    for day in 0...80
        new_ages = Hash.new(0)
        for age in ages.keys.sort()
            if age == 0
                new_ages[6] = new_ages[8] = ages[0]
            else
                new_ages[age - 1] += ages[age]
            end
        end
        ages = new_ages
    end
    return ages.values.sum
end

def part2(input)
    ages = Hash.new(0)
    input.split(",").map(&:to_i).each { |x| ages[x] += 1 }
    for day in 0...256
        new_ages = Hash.new(0)
        for age in ages.keys.sort()
            if age == 0
                new_ages[6] = new_ages[8] = ages[0]
            else
                new_ages[age - 1] += ages[age]
            end
        end
        ages = new_ages
    end
    return ages.values.sum
end

actual = File.open("day6.txt").read

puts part1(actual)
puts part2(actual)

def getChecks(index, width, max)
    [
        index % width == 0 ? -1 : index-width-1,
        index-width,
        index % width == width-1 ? -1 : index-width+1,
        index % width == 0 ? -1 : index-1,
        index % width == width-1 ? -1 : index+1,
        index % width == 0 ? -1 : index+width-1,
        index+width,
        index % width == width-1 ? -1 : index+width+1
    ].filter {|x| x >= 0 && x < max}
end

def part1(input)
    width = input[0].chomp.length
    octopi = input.map {|line| line.chomp.chars.map(&:to_i)}.flatten
    flashCount = 0
    100.times do
        flashes = octopi.map! {|o| o > 9 ? 1 : o+1}.filter_map.with_index {|o,i| i if o > 9}
        used = flashes.clone
        while flashes.length > 0
            checks = getChecks(flashes.shift,width,octopi.length)
            checks.each {|i| octopi[i] += 1}
            checks.filter {|i| octopi[i] > 9 && !used.include?(i) }.each do |i|
                used << i
                flashes << i
            end
        end
        flashCount += used.length
    end
    flashCount
end

def part2(input)
    width = input[0].chomp.length
    octopi = input.map {|line| line.chomp.chars.map(&:to_i)}.flatten
    count = 0
    loop do
        flashes = octopi.map! {|o| o > 9 ? 1 : o+1}.filter_map.with_index {|o,i| i if o > 9}
        if octopi.sum == octopi.length
            return count
        end
        used = flashes.clone
        while flashes.length > 0
            checks = getChecks(flashes.shift,width,octopi.length)
            checks.each {|i| octopi[i] += 1}
            checks.filter {|i| octopi[i] > 9 && !used.include?(i) }.each do |i|
                used << i
                flashes << i
            end
        end
        count += 1
    end
end

actual = File.open("day11.txt").readlines

puts part1(actual)
puts part2(actual)

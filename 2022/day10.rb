def part1(input)
    important_times = [20,60,100,140,180,220]
    clock = 0
    x = 1
    strength = 0
    input.each do |l|
        instr, val = l.split

        time = instr == "noop" ? 1 : 2

        time.abs.times do
            clock += 1
            if important_times.include?(clock)
                strength += clock * x
            end
        end
        x += val.to_i  
    end
    strength
end

def part2(input)
    important_times = [40,80,120,160,200,240]
    clock = 0
    x = 1
    screen = [[]]
    input.each do |l|
        instr, val = l.split
        
        time = instr == "noop" ? 1 : 2

        time.abs.times do
            screen[clock/40] << (((x-1)..(x+1)).include?(clock % 40) ? '#' : '.')
            clock += 1
            screen << [] if important_times.include?(clock)
        end
        x += val.to_i
    end
    screen.map(&:join).join("\n")
end

actual = File.read('./day10.txt').lines

puts part1(actual)
puts part2(actual)
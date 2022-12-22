def part1(input)
    map = {}
    grid, instructions = input.split("\n\n")
    grid.lines.each.with_index do |l,i|
        l.chomp.chars.each.with_index do |c,j|
            next if c == " "
            map[[i, j]] = c
        end
    end
    current = [map.keys.select{|p| p[0] == 0}.sort_by{|p| p[1]}[0], 0]
    
    instructions = instructions.chars
    loop do
        # move
        dist = instructions.shift
        
        loop do
            break if instructions.size == 0 || instructions[0] == "L" || instructions[0] == "R"
            dist << instructions.shift
        end
        dist = dist.to_i
        dist.times do
            next_loc = current[0].clone
            case current[1]
            when 0
                next_loc[1] += 1
            when 1
                next_loc[0] += 1
            when 2
                next_loc[1] -= 1
            when 3
                next_loc[0] -= 1
            end
            if map.has_key?(next_loc)
                break if map[next_loc] == "#"
                current[0] = next_loc
            else
                case current[1]
                when 0
                    next_loc[1] = map.keys.select{|k| k[0] == current[0][0]}.map{|k| k[1]}.min
                when 1
                    next_loc[0] = map.keys.select{|k| k[1] == current[0][1]}.map{|k| k[0]}.min
                when 2
                    next_loc[1] = map.keys.select{|k| k[0] == current[0][0]}.map{|k| k[1]}.max
                when 3
                    next_loc[0] = map.keys.select{|k| k[1] == current[0][1]}.map{|k| k[0]}.max
                end
                break if map[next_loc] == "#"
                current[0] = next_loc
            end
        end
        
        break if instructions.size == 0

        # turn
        current[1] = (current[1] + (instructions.shift == "L" ? -1 : 1)) % 4
    end

    (1000 * (current[0][0]+1)) + (4 * (current[0][1]+1)) + current[1]
end

def part2(input)
    map = {}
    grid, instructions = input.split("\n\n")
    box_size = grid.lines[0].strip.length / 2
    grid.lines.each.with_index do |l,i|
        l.chomp.chars.each.with_index do |c,j|
            next if c == " "
            map[[i, j]] = c
        end
    end
    current = [map.keys.select{|p| p[0] == 0}.sort_by{|p| p[1]}[0], 0]
    instructions = instructions.chars
    loop do
        # move
        dist = instructions.shift
        
        loop do
            break if instructions.size == 0 || instructions[0] == "L" || instructions[0] == "R"
            dist << instructions.shift
        end
        dist = dist.to_i
        dist.times do
            next_loc = current[0].clone
            next_dir = current[1]
            case current[1]
            when 0
                next_loc[1] += 1
            when 1
                next_loc[0] += 1
            when 2
                next_loc[1] -= 1
            when 3
                next_loc[0] -= 1
            end
            if map.has_key?(next_loc)
                break if map[next_loc] == "#"
                current[0] = next_loc
            else
                if current[0][0] < box_size
                    # 1
                    if current[0][1] < box_size * 2
                        case current[1]
                        when 2
                            next_loc = [box_size - 1 - current[0][0] + box_size * 2, 0]
                            next_dir = 0
                        when 3
                            next_loc = [current[0][1] + (box_size * 2), 0]
                            next_dir = 0
                        end
                    # 2
                    else
                        case current[1]
                        when 0
                            next_loc = [box_size - 1 - current[0][0] + (box_size * 2), box_size * 2 - 1]
                            next_dir = 2
                        when 1
                            next_loc = [current[0][1] - box_size, box_size * 2 - 1]
                            next_dir = 2
                        when 3
                            next_loc = [box_size * 4 - 1, current[0][1] - (box_size * 2)]
                            next_dir = 3
                        end
                    end
                elsif current[0][0] < box_size * 2
                    #3
                    case current[1]
                    when 0
                        next_loc = [box_size - 1, current[0][0] + box_size]
                        next_dir = 3
                    when 2
                        next_loc = [box_size * 2, current[0][0] - box_size]
                        next_dir = 1
                    end
                elsif current[0][0] < box_size * 3
                    #4
                    if current[0][1] < box_size
                        case current[1]
                        when 2
                            next_loc = [(box_size*3) - 1 - current[0][0], box_size]
                            next_dir = 0
                        when 3
                            next_loc = [current[0][1] + box_size, box_size]
                            next_dir = 0
                        end
                    #5
                    else
                        case current[1]
                        when 0
                            next_loc = [(box_size*3) - 1 - current[0][0], box_size * 3 - 1]
                            next_dir = 2
                        when 1
                            next_loc = [current[0][1] + (box_size*2), box_size - 1]
                            next_dir = 2
                        end
                    end
                else
                    #6
                    case current[1]
                    when 0
                        next_loc = [box_size * 3 - 1, current[0][0] - box_size*2]
                        next_dir = 3
                    when 1
                        next_loc = [0, current[0][1] + (box_size * 2)]
                        next_dir = 1
                    when 2
                        next_loc = [0, current[0][0] - (box_size * 2)]
                        next_dir = 1
                    end
                end
                break if map[next_loc] == "#"
                current = [next_loc, next_dir]
            end
        end
        
        break if instructions.size == 0

        # turn
        current[1] = (current[1] + (instructions.shift == "L" ? -1 : 1)) % 4
    end

    (1000 * (current[0][0]+1)) + (4 * (current[0][1]+1)) + current[1]
end

actual = File.read('./day22.txt')

puts part1(actual)
puts part2(actual)
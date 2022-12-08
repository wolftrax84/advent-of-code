def part1(heightMap)
    maxRow = heightMap.count - 1
    maxCol = heightMap[0].count - 1

    visible_count = maxRow * 2 + maxCol * 2
    (1...maxRow).to_a().product((1...maxCol).to_a()).each do |(row,col)|
        val = heightMap[row][col]
        blocked = Array.new(4, false)
        dist = 1
        visible = false
        loop do
            # up
            if !blocked[0]
                if row - dist < 0 
                    visible = true
                    break
                elsif heightMap[row-dist][col] >= val
                    blocked[0] = true
                end
            end

            # down
            if !blocked[2]
                if row + dist > maxRow
                    visible = true
                    break
                elsif heightMap[row+dist][col] >= val
                    blocked[2] = true
                end
            end

            # left
            if !blocked[3]
                if col - dist < 0
                    visible = true
                    break
                elsif heightMap[row][col-dist] >= val
                    blocked[3] = true
                end
            end

            # right
            if !blocked[1]
                if col + dist > maxCol
                    visible = true
                    break
                elsif heightMap[row][col+dist] >= val
                    blocked[1] = true
                end
            end

            break if !blocked.include?(false)
            dist += 1
        end
        if visible
            visible_count += 1
        end
    end
    visible_count
end

def part2(heightMap)
    maxRow = heightMap.count - 1
    maxCol = heightMap[0].count - 1
    scores = []
    (0...maxRow).to_a().product((0...maxRow).to_a()).each do |(row,col)|
        val = heightMap[row][col]
        checked = Array.new(4, false)
        local_scores = Array.new(4, 0)
        dist = 1
        loop do
            # up
            if (!checked[0])
                if row - dist < 0 
                    local_scores[0] = dist-1
                    checked[0] = true
                elsif heightMap[row-dist][col] >= val
                    local_scores[0] = dist
                    checked[0] = true
                end
            end

            # down
            if (!checked[2])
                if row + dist > maxRow
                    local_scores[2] = dist-1
                    checked[2] = true
                elsif heightMap[row+dist][col] >= val
                    local_scores[2] = dist
                    checked[2] = true
                end
            end
            
            # left
            if (!checked[3])
            if col - dist < 0 
                local_scores[3] = dist-1
                checked[3] = true
            elsif heightMap[row][col-dist] >= val
                local_scores[3] = dist
                checked[3] = true
            end
        end

            # right
            if (!checked[1])
            if col + dist > maxCol
                local_scores[1] = dist-1
                checked[1] = true
            elsif heightMap[row][col+dist] >= val
                local_scores[1] = dist
                checked[1] = true
            end
        end
            break if !checked.include?(false)
            dist += 1
        end
        scores << local_scores.inject(:*)
    end
    scores.max
end

actual = File.read('./day8.txt').lines

heightMap = actual.map(&:chomp).map{|l| l.chars.map(&:to_i)}

puts part1(heightMap)
puts part2(heightMap)

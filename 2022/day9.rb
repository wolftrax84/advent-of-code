def func(input, segment_count)
    tail_positions = [[0,0]]
    segments = Array.new(segment_count, Array.new(2,0))
    input.each do |move|
        dir, dist = move.split
        dist.to_i.times do
            case dir
                when 'R'
                    segments[0] = [segments[0][0], segments[0][1]+1]
                when 'L'
                    segments[0] = [segments[0][0], segments[0][1]-1]
                when 'D'
                    segments[0] = [segments[0][0] + 1, segments[0][1]]
                when 'U' 
                    segments[0] = [segments[0][0] - 1, segments[0][1]]
            end

            (0...(segment_count-1)).each.with_index do |i|
                if (segments[i][0] - segments[i+1][0]).abs > 1
                    segments[i+1] = [(segments[i+1][0]+segments[i][0])/2, segments[i][1]]
                    if i+1 == (segment_count-1)
                        tail_positions << segments[i+1]
                    end
                elsif (segments[i][1] - segments[i+1][1]).abs > 1
                    segments[i+1] = [segments[i][0], (segments[i][1]+segments[i+1][1])/2]
                    if i+1 == (segment_count-1)
                        tail_positions << segments[i+1]
                    end
                end
            end
        end
    end
    return tail_positions.uniq.count
end

actual = File.read('./day9.txt').lines

puts func(actual,2)
puts func(actual,10)

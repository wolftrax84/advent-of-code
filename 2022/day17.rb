class Rock
    def initialize points, width = 0
        @points = points
        @width = width
    end

    attr_accessor :points
    attr_accessor :width
end

def rocks = [Rock.new([[0,1,2,3]], 4),Rock.new([[1],[0,1,2],[1]],3),Rock.new([[0,1,2],[2],[2]],3),Rock.new([[0],[0],[0],[0]],1),Rock.new([[0,1],[0,1]],2)]

def part1(input)
    map = Hash.new {|h,k| h[k] = []}
    input_idx = -1
    map[0] = [0,1,2,3,4,5,6]
    2022.times.with_index do |i|
        rock_idx = i%rocks.count
        rock = rocks[rock_idx]
        corner = [2, map.keys.max+4]
        loop do
            next_corner = corner.clone

            input_idx += 1
            wind_dir = input[input_idx % input.count]
            if rock.points.map.with_index {|row, i|
                row.map { |point| 
                    pt = next_corner[0] + point + wind_dir
                    pt != -1 && pt != 7 && (!map.has_key?(next_corner[1]+i) || !map[next_corner[1]+i].include?(pt))
                }.all?}.all?
                next_corner[0] += wind_dir
            end

            next_corner[1] -= 1

            if next_corner[1] > map.keys.max
                corner = next_corner
                next
            end

            if (next_corner[1] == 0 || rock.points[0].map{|p| p+next_corner[0]}.intersection(map[next_corner[1]]).count > 0) || (rock_idx == 1 && rock.points[1].map{|p| p+next_corner[0]}.intersection(map[next_corner[1]+1]).count > 0)
                next_corner[1] += 1
                rock.points.each.with_index do |c,r|
                    map[r+next_corner[1]] = map[r+next_corner[1]].union(c.map{|p| p+next_corner[0]})
                end
                break
            else
                corner = next_corner
            end
        end
    end
    map.keys.max
end

def find_cycle(input)
    cache = Hash.new {|h,k| h[k] = []}
    map = Hash.new {|h,k| h[k] = []}
    input_idx = -1
    map[0] = [0,1,2,3,4,5,6]
    2000.times.with_index do |i|
        rock_idx = i%rocks.count
        rock = rocks[rock_idx]
        corner = [2, map.keys.max+4]
        loop do
            next_corner = corner.clone
            input_idx += 1
            wind_dir = input[input_idx % input.count]
            if rock.points.map.with_index {|row, i|
                row.map { |point| 
                    pt = next_corner[0] + point + wind_dir
                    pt != -1 && pt != 7 && (!map.has_key?(next_corner[1]+i) || !map[next_corner[1]+i].include?(pt))
                }.all?}.all?
                next_corner[0] += wind_dir
            end

            next_corner[1] -= 1

            if next_corner[1] > map.keys.max
                corner = next_corner
                next
            end

            if (next_corner[1] == 0 || rock.points[0].map{|p| p+next_corner[0]}.intersection(map[next_corner[1]]).count > 0) || (rock_idx == 1 && next_corner[1] + 1 <= map.keys.max && rock.points[1].map{|p| p+next_corner[0]}.intersection(map[next_corner[1]+1]).count > 0)
                next_corner[1] += 1
                rock.points.each.with_index do |c,r|
                    map[r+next_corner[1]] = map[r+next_corner[1]].union(c.map{|p| p+next_corner[0]})
                end
                break
            else
                corner = next_corner
            end
        end
        col_maxes = Array.new(7, 0)
        z = map.keys.max
        loop do
            map[z].each.with_index do |c|
                next if col_maxes[c] != 0
                col_maxes[c] = z
            end
            break if col_maxes.all?{|x| x != 0}
            z -= 1
            break if z == 0
        end
        offset = col_maxes.min
        col_maxes.map!{|x| x-offset}
        cache_key = [*col_maxes, rock_idx, input_idx % input.count].join(":")
        if cache.has_key?(cache_key)
            return [cache, cache_key,[i+1, map.keys.max]]
        end
        cache[cache_key] = [i+1, map.keys.max]
    end
end

def part2(input)
    cache, cycle_key, cycle_end = find_cycle(input)
    cycle_height = cycle_end[1] - cache[cycle_key][1]
    cycle_size = cycle_end[0] - cache[cycle_key][0]
    cycle_count = (1000000000000-cache[cycle_key][0]) / cycle_size
    outro_count = (1000000000000-cache[cycle_key][0]) % cycle_size
    excess = cache.entries.find{|k,v| v[0] == outro_count+cache[cycle_key][0]}[1][1]
    return (cycle_height * cycle_count) + excess
end

actual = File.read('./day17.txt').chars.map{|c| c == '>' ? 1 : -1}

puts part1(actual)
puts part2(actual)

class Rock
    def initialize points, width
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
    1000000000000.times.with_index do |i|
        if i > 100
            map.delete(i-100)
        end
        rock_idx = i%rocks.count
        rock = rocks[rock_idx]
        corner = [2, map.keys.max+4]
        # p "starting corner: #{corner}"
        loop do
            next_corner = corner.clone

            input_idx += 1
            # wind effect
            wind_dir = input[input_idx % input.count]

            # p "#{rock.points.map.with_index {|row, i|
            #     # p "#{row}"
            #     p row.map { |point| 
            #         pt = next_corner[0] + point + wind_dir
            #         # p "#{pt}"
            #         pt != -1 && pt != 7 && (!map.has_key?(next_corner[1]+i) || !map[next_corner[1]+i].include?(pt))
            #     }}}"
            # test 
            if rock.points.map.with_index {|row, i|
                row.map { |point| 
                    pt = next_corner[0] + point + wind_dir
                    pt != -1 && pt != 7 && (!map.has_key?(next_corner[1]+i) || !map[next_corner[1]+i].include?(pt))
                }.all?}.all?
                next_corner[0] += wind_dir
            end

            # p "go #{wind_dir}"
            # case wind_dir
            # when "<"

            #     # if corner[0] > 0
            #     #     if rock_idx == 1 && (!map.has_key?(corner[1]+1) || !map[corner[1]+1].include?(corner[0]-1))
            #     #         next_corner[0] -= 1
            #     #     else
            #     #         if !map.has_key?(corner[1]) || !map[corner[1]].include?(corner[0]-1)
            #     #             next_corner[0] -= 1
            #     #         end
            #     #     end
            #     # end

            #     # p "check "
            #     # next_corner[0] -= 1 if corner[0] > 0 && (!map.has_key?(corner[1]) || !map[corner[1]].include?(corner[0]-1)) && (!map.has_key?(corner[1]+1) || !map[corner[1]+1].include?(corner[0]-1))
            # when ">"
            #     # if corner[0]+rock.width < 7
            #     #     if rock_idx == 1 &&  (!map.has_key?(corner[1]+1) || !map[corner[1]+1].include?(corner[0]+rock.width))
            #     #         next_corner[0] += 1
            #     #     else
            #     #         if !map.has_key?(corner[1]) || !map[corner[1]].include?(corner[0]+rock.width)
            #     #             next_corner[0] += 1
            #     #         end
            #     #     end
            #     # end
            #     # p "check: #{corner[1]} #{corner[0]+rock.width}"
            #     # next_corner[0] += 1 if corner[0]+rock.width < 7 && (!map.has_key?(corner[1]) || !map[corner[1]].include?(corner[0]+rock.width))
            # end
            # p "next corner 1 #{next_corner}"


            # move down
            next_corner[1] -= 1

            # p "next corner #{next_corner}"

            if next_corner[1] > map.keys.max
                # p "skip"
                corner = next_corner
                next
            end
            # p "next corner 3 #{next_corner}"


            # check if stop
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

def part2(input)

end

actual = File.read('./day17.txt').chars.map{|c| c == '>' ? 1 : -1}

temp = '>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>'.chars.map{|c| c == '>' ? 1 : -1}
# >>>< <><> ><<<> ><>>><< <>>> <<<> <<<> ><>>< <>>

puts part1(actual)
puts part2(actual)

def getRotations(x,y,z)
    return [
        [x,y,z],
        [x,y*-1,z*-1],
        [x,z,y*-1],
        [x,z*-1,y],
        [x*-1,z,y],
        [x*-1,z*-1,y*-1],
        [x*-1,y,z*-1],
        [x*-1,y*-1,z],
        [y,z,x],
        [y,z*-1,x*-1],
        [y,x,z*-1],
        [y,x*-1,z],
        [y*-1,x,z],
        [y*-1,x*-1,z*-1],
        [y*-1,z,x*-1],
        [y*-1,z*-1,x],
        [z,x,y],
        [z,x*-1,y*-1],
        [z,y,x*-1],
        [z,y*-1,x],
        [z*-1,y,x],
        [z*-1,y*-1,x*-1],
        [z*-1,x,y*-1],
        [z*-1,x*-1,y]        
    ]
end

def getArrangementMap(points)
    arrangementMap = {}
    points.permutation(2).each {|x,y| arrangementMap[[(x[0]-y[0]),(x[1]-y[1]),(x[2]-y[2])]] = [x,y]}
    arrangementMap
end

def solveScanners(data)
    zeroPoints = data[0].map {|x| x[0]}
    solved_points = zeroPoints
    solved_scanners = [[getArrangementMap(zeroPoints),0,0,0,0]]
    unsolved_scanners = (1..data.length-1).to_a
    while !unsolved_scanners.empty?
        catch :match_found do
            check_scanner = unsolved_scanners.shift
            for solved_arrangement,a_idx,a_dx,a_dy,a_dz in solved_scanners
                for rotation in 0...24
                    check_points = data[check_scanner].map {|x| x[rotation]}
                    check_arrangement = getArrangementMap(check_points)
                    matches = check_arrangement.keys.intersection(solved_arrangement.keys)
                    if matches.length >= 132
                        p1,p2 = solved_arrangement[matches[0]], check_arrangement[matches[0]]
                        dx,dy,dz = p1[0][0]-p2[0][0]+a_dx,p1[0][1]-p2[0][1]+a_dy,p1[0][2]-p2[0][2]+a_dz
                        solved_points = solved_points.union(check_points.map {|p| [p[0]+dx,p[1]+dy,p[2]+dz]})
                        solved_scanners.unshift([check_arrangement, check_scanner, dx,dy,dz])
                        throw :match_found
                    end
                end
            end
            unsolved_scanners << check_scanner
        end
    end
    return [solved_points, solved_scanners]
end

def part1(input)
    solveScanners(input.split("\n\n").map do |s|
        s.lines[1..].map do |line| 
            getRotations(*line.chomp.split(",").map(&:to_i)) 
        end
    end)[0].size
end

def part2(input)
    solveScanners(input.split("\n\n").map do |s|
        s.lines[1..].map do |line| 
            getRotations(*line.chomp.split(",").map(&:to_i)) 
        end
    end)[1].combination(2).map { |a,b| 
        _,_,a_dx,a_dy,a_dz = a
        _,_,b_dx,b_dy,b_dz = b
        (a_dx-b_dx).abs + (a_dy-b_dy).abs + (a_dz-b_dz).abs
    }.max
end

actual = File.open("day19.txt").read

puts part1(actual)
puts part2(actual)

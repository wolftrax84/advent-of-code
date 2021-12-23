def part1(input)
    lights = Hash.new(false)
    input.each do |line|
        matches = line.chomp.match(/(on|off) x=(-*[0-9]+)..(-*[0-9]+),y=(-*[0-9]+)..(-*[0-9]+),z=(-*[0-9]+)..(-*[0-9]+)/).captures
        on = matches[0] == "on"
        x1,x2 = matches[1..2].map(&:to_i)
        y1,y2 = matches[3..4].map(&:to_i)
        z1,z2 = matches[5..6].map(&:to_i)
        for x in ([x1,-50].max)..([x2,50].min)
            for y in ([y1,-50].max)..([y2,50].min)
                for z in ([z1,-50].max)..([z2,50].min)
                    lights[[x,y,z]] = on
                end
            end
        end
    end
    return lights.values.tally[true]
end

def intersection(a,b)
    nx = [[a[1][0],b[1][0]].max, [a[1][1],b[1][1]].min]
    ny = [[a[2][0],b[2][0]].max, [a[2][1],b[2][1]].min]
    nz = [[a[3][0],b[3][0]].max, [a[3][1],b[3][1]].min]
    if nx[0] < nx[1] && ny[0] < ny[1] && nz[0] < nz[1]
        return [-1 * b[0],nx,ny,nz]
    else
        return nil
    end
end

def getCubeSize(cube)
    return cube[0] * (cube[1][1]-cube[1][0]+1) * (cube[2][1]-cube[2][0]+1) * (cube[3][1]-cube[3][0]+1)
end

def part2(input)
    cubes = []
    input.each do |line|
        matches = line.chomp.match(/(on|off) x=(-*[0-9]+)..(-*[0-9]+),y=(-*[0-9]+)..(-*[0-9]+),z=(-*[0-9]+)..(-*[0-9]+)/).captures
        on = matches[0] == "on"
        x1,x2 = matches[1..2].map(&:to_i)
        y1,y2 = matches[3..4].map(&:to_i)
        z1,z2 = matches[5..6].map(&:to_i)
        cube = [1,[x1,x2],[y1,y2],[z1,z2]]

        newCubes = cubes.map {|other| intersection(cube,other)}.compact
        cubes.concat(newCubes)

        cubes << cube if on
    end
    puts cubes.map { getCubeSize(_1) }.sum
end

actual = File.open("day22.txt").readlines

puts part1(actual)
puts part2(actual)

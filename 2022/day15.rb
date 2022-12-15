class Sensor
    def initialize x, y, r
        @x = x
        @y = y
        @r = r
    end

    attr_accessor :x
    attr_accessor :y
    attr_accessor :r
    attr_accessor :boundary
end

def part1(input, row)
    sensors = []
    input.each do |l|
        sensor = []
        beacon = []
        sensor[0], sensor[1], beacon[0], beacon[1] = l.chomp.match(/Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)/).captures.map(&:to_i)
        sensors << Sensor.new(*sensor, ((sensor[0] - beacon[0]).abs + (sensor[1] - beacon[1]).abs))
    end
    covered_points = []
    sensors.each do |s|
        next if (s.y - row).abs > s.r
        overflow = ((s.y - row).abs - s.r).abs
        ((s.x-overflow)...(s.x+overflow)).each do |newY|
            covered_points << [row, newY]
        end
    end
    return covered_points.uniq.count
end

def part2(input, max)
    sensors = []
    input.each do |l|
        sensor = []
        beacon = []
        sensor[0], sensor[1], beacon[0], beacon[1] = l.chomp.match(/Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)/).captures.map(&:to_i)
        sensors << Sensor.new(*sensor, ((sensor[0] - beacon[0]).abs + (sensor[1] - beacon[1]).abs))
    end
    sensors.each do |s|
        boundary_points = []
        ((s.y-s.r-1)..(s.y+s.r+1)).each do |row|
            next if row < 0 || row > max
            overflow = ((s.y - row).abs - s.r).abs
            
            boundary_points << [s.x-overflow-1, row] if s.x-overflow-1 >= 0
            boundary_points << [s.x+overflow+1, row] if s.x+overflow+1 <= max
        end
        boundary_points.uniq!
        boundary_points.each do |bp|
            scanned = false
            sensors.each do |s|
                dist = ((s.x - bp[0]).abs + (s.y - bp[1]).abs)
                next if dist > s.r
                scanned = true
                break
            end
            return bp[0]*4000000+bp[1] if scanned == false
        end
    end
end

actual = File.read('./day15.txt').lines

puts part1(actual, 2000000)
puts part2(actual, 4000000 )

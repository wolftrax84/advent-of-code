class Unit
    def initialize location, type, ap
        @id = location
        @location = location
        @health = 200
        @enemies = type === "E" ? $goblins : $elves
        @allies = type === "E" ? $elves : $goblins
        @ap = ap
    end
    attr_reader :id
    attr_accessor :location
    attr_accessor :health
    attr_accessor :enemies
    attr_accessor :allies
    attr_reader :ap

    def get_neighbors(x,y)
        return [[x-1,y],[x,y-1],[x,y+1],[x+1,y]]
    end

    def take_turn
        # check if dead
        return false if @health <= 0

        # check end state
        return true if @enemies.empty?

        move

        attack

        return false
    end

    def move
        # check if already in range
        neighbors = get_neighbors(*@location)
        return if neighbors.any? {|n| @enemies.include?(n)}

        # calculate available spaces in attack range
        targets = Set.new()
        @enemies.each do |enemy|
            north, west, east, south = get_neighbors(*enemy)
            targets.add(north) if !$occupied.include?(north)
            targets.add(west) if !$occupied.include?(west)
            targets.add(east) if !$occupied.include?(east)
            targets.add(south) if !$occupied.include?(south)
        end

        return if targets.size === 0

        # set up variables
        visited = Array.new(4) {Set.new}
        all_next_spaces = [[],[],[],[]]
        closest_targets = Array.new(4) {[Float::INFINITY, Float::INFINITY, Float::INFINITY]}
        
        # initialize possible moves
        north, west, east, south = *neighbors
        if targets.include?(north)
            updateLocation(north)
            return
        elsif !$occupied.include?(north)
            all_next_spaces[0] << [north]
            visited[0].add(north)
        end
        if targets.include?(west)
            updateLocation(west)
            return
        elsif !$occupied.include?(west)
            all_next_spaces[1] << [west]
            visited[1].add(west)
        end
        if targets.include?(east)
            updateLocation(east)
            return
        elsif !$occupied.include?(east)
            all_next_spaces[2] << [east]
            visited[2].add(east)
        end
        if targets.include?(south)
            updateLocation(south)
            return
        elsif !$occupied.include?(south)
            all_next_spaces[3] << [south]
            visited[3].add(south)
        end

        dist = 0
        loop do
            break if all_next_spaces.all? {|x| x.empty?}
            dist += 1
            all_next_spaces.each.with_index do |dir_next_spaces, index|
                next if dir_next_spaces.empty?
                next_spaces = dir_next_spaces.shift
                next_next_spaces = Set.new
                found_target = false
                next_spaces.each do |next_space|
                    next_north, next_west, next_east, next_south = get_neighbors(*next_space)
                    if targets.include?(next_north)
                        if (next_north[0] < closest_targets[index][0] || (next_north[0] === closest_targets[index][0] && next_north[1] < closest_targets[index][1]))
                            closest_targets[index] = [*next_north,dist]
                            found_target = true
                        end
                    elsif !$occupied.include?(next_north) && !visited[index].include?(next_north)
                        visited[index].add(next_north)
                        next_next_spaces.add(next_north)
                    end
                    if targets.include?(next_west)
                        if (next_west[0] < closest_targets[index][0] || (next_west[0] === closest_targets[index][0] && next_west[1] < closest_targets[index][1]))
                            closest_targets[index] = [*next_west,dist]
                            found_target = true
                        end
                    elsif !$occupied.include?(next_west) && !visited[index].include?(next_west)
                        visited[index].add(next_west)
                        next_next_spaces.add(next_west)
                    end
                    if targets.include?(next_east)
                        if (next_east[0] < closest_targets[index][0] || (next_east[0] === closest_targets[index][0] && next_east[1] < closest_targets[index][1]))
                            closest_targets[index] = [*next_east,dist]
                            found_target = true
                        end
                    elsif !$occupied.include?(next_east) && !visited[index].include?(next_east)
                        visited[index].add(next_east)
                        next_next_spaces.add(next_east)
                    end
                    if targets.include?(next_south)
                        if (next_south[0] < closest_targets[index][0] || (next_south[0] === closest_targets[index][0] && next_south[1] < closest_targets[index][1]))
                            closest_targets[index] = [*next_south,dist]
                            found_target = true
                        end
                    elsif !$occupied.include?(next_south) && !visited[index].include?(next_south)
                        visited[index].add(next_south)
                        next_next_spaces.add(next_south)
                    end
                end
                all_next_spaces[index] << (next_next_spaces) if !found_target && next_next_spaces.size > 0
            end
        end

        # check if no targets available
        return if closest_targets.all? {|t| t === [Float::INFINITY, Float::INFINITY, Float::INFINITY]}

        move_dir = closest_targets.index(closest_targets.sort_by {|e| [e[2], e[0], e[1]]}.shift)
        next_location = []
        case (move_dir)
        when 0
            next_location = [@location[0]-1, @location[1]]
        when 1
            next_location = [@location[0], @location[1]-1]
        when 2
            next_location = [@location[0], @location[1]+1]
        when 3
            next_location = [@location[0]+1, @location[1]]
        end
        updateLocation(next_location)
    end

    def updateLocation(next_location)
        @allies.delete(@location)
        $occupied.delete(@location)
        @allies.add(next_location)
        $occupied.add(next_location)
        @location = next_location
    end

    def attack
        # check for enemies in range
        neighbors = get_neighbors(*@location)
        return if !neighbors.any? {|n| @enemies.include?(n)}

        # pick target
        targets = neighbors.map {|n| @enemies.include?(n) ? $units.select {|u| u.location === n}[0] : nil}
        targets = targets.select {|t| t != nil}.sort_by! {|target| [target.health, target.location[0], target.location[1]]}

        # attack target
        targets[0].health -= @ap

        # check if target died
        if targets[0].health <= 0
            @enemies.delete(targets[0].location)
            $occupied.delete(targets[0].location)
            targets[0].location = [-1,-1]
        end
    end
end

$map = File.read("./day15.txt").chomp
$units = Array.new
$elves = Set.new
$goblins = Set.new
$occupied = Set.new
$elf_ap = 3

def resetGlobals
    $units = Array.new
    $elves = Set.new
    $goblins = Set.new
    $occupied = Set.new
    $map.lines(chomp: true).each.with_index do |line,x|
        line.chars.each.with_index do |c,y|
            next if c === '.'
            $occupied.add([x,y])
            if c === "E"
                $elves.add([x,y]) 
                $units << Unit.new([x,y], c, $elf_ap)
            end
            if c === "G"
                $goblins.add([x,y]) 
                $units << Unit.new([x,y], c, 3)
            end
        end
    end
end

def run_round(i)
    $units.each do |unit|
        return true if unit.take_turn()
    end
    $units.sort_by! {|u| [u.location[0], u.location[1]]}
    return false
end

def part1
    $elf_ap = 3
    resetGlobals()
    loop.with_index do |_, i|
        return $units.map {|u| u.health < 0 ? 0 : u.health}.sum * i if run_round(i)
    end
end

def part2
    $elf_ap = 3
    loop.with_index do |_, i|
        $elf_ap = $elf_ap + 1
        resetGlobals()
        elf_count = $elves.size
        loop.with_index do |_, i2|
            result = run_round(i2)
            if result == true
                return $units.map {|u| u.health < 0 ? 0 : u.health}.sum * i2 if elf_count == $elves.size
                break
            end
        end
    end
end

puts part1()
puts part2()

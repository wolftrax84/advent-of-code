class Blueprint
    def initialize index, ore_cost, clay_cost, obsidian_ore_cost, obsidian_clay_cost, geode_ore_cost, geode_obsidian_cost
        @index = index
        @ore = ore_cost
        @clay = clay_cost
        @obsidian_ore = obsidian_ore_cost
        @obsidian_clay = obsidian_clay_cost
        @geode_ore = geode_ore_cost
        @geode_obsidian = geode_obsidian_cost
        @max_ore = [ore_cost, clay_cost, obsidian_ore_cost, geode_ore_cost].max
    end

    attr_accessor :index
    attr_accessor :ore
    attr_accessor :clay
    attr_accessor :obsidian_ore
    attr_accessor :obsidian_clay
    attr_accessor :geode_ore
    attr_accessor :geode_obsidian
    attr_accessor :max_ore
end

$cache = {}

def dfs(blueprint, time_remaining, resources, robots, robot_to_build)
    # base case
    return resources[3] if time_remaining < 1
    
    if $cache.has_key?([*robots, robot_to_build, time_remaining])
        if $cache[[*robots,robot_to_build,time_remaining]][0].map.with_index{|r,i| r >= resources[i]}.all?
            return $cache[[*robots, robot_to_build, time_remaining]][1]
        end
    end

    next_robots = robots.clone

    next_resources = resources.clone

    next_time_remaining = time_remaining

    # build robots
    loop do
        case robot_to_build
        when :ore
            if next_resources[0] >= blueprint.ore
                next_robots[0] += 1
                next_resources[0] -= blueprint.ore
                break
            else
                next_resources = next_resources.map.with_index {|r,i| r += robots[i]}
                next_time_remaining -= 1
                if next_time_remaining < 1
                    return next_resources[3]
                end
            end            
        when :clay
            if next_resources[0] >= blueprint.clay
                next_robots[1] += 1
                next_resources[0] -= blueprint.clay
                break
            else
                next_resources = next_resources.map.with_index {|r,i| r += robots[i]}
                next_time_remaining -= 1
                if next_time_remaining < 1
                    return next_resources[3]
                end
            end   
        when :obsidian
            if next_resources[0] >= blueprint.obsidian_ore && next_resources[1] >= blueprint.obsidian_clay
                next_robots[2] += 1
                next_resources[0] -= blueprint.obsidian_ore
                next_resources[1] -= blueprint.obsidian_clay
                break
            else
                next_resources = next_resources.map.with_index {|r,i| r += robots[i]}
                next_time_remaining -= 1
                if next_time_remaining < 1
                    return next_resources[3]
                end
            end  
        when :geode
            if next_resources[0] >= blueprint.geode_ore && next_resources[2] >= blueprint.geode_obsidian
                next_robots[3] += 1
                next_resources[0] -= blueprint.geode_ore
                next_resources[2] -= blueprint.geode_obsidian
                break
            else
                next_resources = next_resources.map.with_index {|r,i| r += robots[i]}
                next_time_remaining -= 1
                if next_time_remaining < 1
                    return next_resources[3]
                end
            end  
        end
    end

    # collect resources
    next_resources = next_resources.map.with_index {|r,i| r += robots[i]}

    next_time_remaining -= 1
    
    possible_robots = []
    possible_robots << :ore if next_robots[0] < blueprint.max_ore
    possible_robots << :clay if next_robots[1] < blueprint.obsidian_clay
    possible_robots << :obsidian if next_robots[2] < blueprint.geode_obsidian && next_robots[1] > 0
    possible_robots << :geode if next_robots[1] > 0
    best = possible_robots.map {|next_robot| dfs(blueprint, next_time_remaining, next_resources.clone, next_robots.clone, next_robot)}.max
    $cache[[*robots, robot_to_build, time_remaining]] = [resources, best]
    return best
end

def part1(input)
    total_quality = 0
    input.each do |l|
        blueprint = Blueprint.new(*l.match(/Blueprint (\d+): Each ore robot costs (\d+) ore\. Each clay robot costs (\d+) ore\. Each obsidian robot costs (\d+) ore and (\d+) clay\. Each geode robot costs (\d+) ore and (\d+) obsidian\./).captures.map(&:to_i))
        $cache = {}
        total_quality += ([:ore, :clay].map {|next_robot|
            thing = dfs(blueprint, 24, [0,0,0,0], [1,0,0,0], next_robot)
            thing
        }.max)*blueprint.index
    end
    total_quality
end

def part2(input)
    scores = 1
    input.take(3).each do |l|
        blueprint = Blueprint.new(*l.match(/Blueprint (\d+): Each ore robot costs (\d+) ore\. Each clay robot costs (\d+) ore\. Each obsidian robot costs (\d+) ore and (\d+) clay\. Each geode robot costs (\d+) ore and (\d+) obsidian\./).captures.map(&:to_i))
        $cache = {}
        scores *= [:ore, :clay].map { |next_robot|
            thing = dfs(blueprint, 32, [0,0,0,0], [1,0,0,0], next_robot)
            thing
        }.max
    end 
    scores   
end

actual = File.read('./day19.txt').lines

puts part1(actual)
puts part2(actual)

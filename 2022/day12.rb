class Node
    def initialize(x,y,height,distance)
        @x = x
        @y = y
        @height = height
        @visited = false
        @distance = distance
    end

    attr_accessor :x
    attr_accessor :y
    attr_accessor :height
    attr_accessor :visited
    attr_accessor :distance

    def loc
        [@x, @y]
    end
end

def part1(input)
    height_map = []
    unvisited = []
    dest = []
    input.each.with_index do |l,i|
        height_map << []
        l.chars.each.with_index do |c,j|
            if c == "S"
                node = Node.new(i,j,0,0)
                height_map[i] << node
                unvisited << node
            elsif c == "E"
                dest = [i,j]
                height_map[i] << Node.new(i,j,25,999999999)
            else
                node = Node.new(i,j,c.ord - 97,999999999)
                height_map[i] << Node.new(i,j,c.ord - 97,999999999)
            end
        end
    end
    
    

    loop do
        current_node = unvisited.min_by{|n| n.distance}
        if current_node.loc == dest
            return current_node.distance
        end
        neighbors = []
        if current_node.x != 0
            n = height_map[current_node.x-1][current_node.y]
            if n.height <= current_node.height + 1 && !n.visited
                neighbors << n
            end
        end
        if current_node.y != 0
            n = height_map[current_node.x][current_node.y-1]
            if n.height <= current_node.height + 1 && !n.visited
                neighbors << n
            end
        end
        if current_node.x != height_map.count-1
            n = height_map[current_node.x+1][current_node.y]
            if n.height <= current_node.height + 1 && !n.visited
                neighbors << n
            end
        end
        if current_node.y != height_map[0].count-1
            n = height_map[current_node.x][current_node.y+1]
            if n.height <= current_node.height + 1 && !n.visited
                neighbors << n
            end
        end
        neighbors.each do |node|
            unvisited << node
            if current_node.distance + 1 < node.distance
                node.distance = current_node.distance + 1
                
            end
        end
        current_node.visited = true
        unvisited.delete_if{|n| n.visited}
        break if unvisited.count == 0
    end
end


def part2(input)
    height_map = []
    unvisited = []
    input.each.with_index do |l,i|
        height_map << []
        l.chars.each.with_index do |c,j|
            if c == "S"
                height_map[i] << Node.new(i,j,0,999999999)
            elsif c == "E"
                node = Node.new(i,j,25,0)
                height_map[i] << node
                unvisited << node
            else
                height_map[i] << Node.new(i,j,c.ord - 97,999999999)
            end
        end
    end   

    loop do
        current_node = unvisited.min_by{|n| n.distance}
        if current_node.height == 0
            return current_node.distance
        end
        neighbors = []
        if current_node.x != 0
            n = height_map[current_node.x-1][current_node.y]
            if n.height >= current_node.height - 1 && !n.visited
                neighbors << n
            end
        end
        if current_node.y != 0
            n = height_map[current_node.x][current_node.y-1]
            if n.height >= current_node.height - 1 && !n.visited
                neighbors << n
            end
        end
        if current_node.x != height_map.count-1
            n = height_map[current_node.x+1][current_node.y]
            if n.height >= current_node.height - 1 && !n.visited
                neighbors << n
            end
        end
        if current_node.y != height_map[0].count-1
            n = height_map[current_node.x][current_node.y+1]
            if n.height >= current_node.height - 1 && !n.visited
                neighbors << n
            end
        end
        neighbors.each do |node|
            unvisited << node
            if current_node.distance + 1 < node.distance
                node.distance = current_node.distance + 1
            end
        end
        current_node.visited = true
        unvisited.delete_if{|n| n.visited}
        break if unvisited.count == 0
    end
end

actual = File.read('./day12.txt').lines.map(&:chomp)

puts part1(actual)
puts part2(actual)

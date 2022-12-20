class Node 
    def initialize value
        @value = value
    end

    attr_accessor :next_node
    attr_accessor :value
end

def part1(input)
    nodes = []
    input.each.with_index do |l|
        nodes << Node.new(l)
    end
    nodes.each.with_index do |n,i|
        n.next_node = i == (nodes.count-1) ? nodes.first : nodes[i+1]
    end
    current_node = nodes[0]
    nodes.count.times do
        next_idx = (nodes.index(current_node) + current_node.value) % (nodes.count-1)
        nodes.delete(current_node)
        nodes.insert(next_idx, current_node)
        current_node = current_node.next_node
    end

    final_map = nodes.map{|n| n.value}
    a = final_map[(final_map.index(0)+1000)%final_map.count]
    b = final_map[(final_map.index(0)+2000)%final_map.count]
    c = final_map[(final_map.index(0)+3000)%final_map.count]
    a + b + c
end

def part2(input)
    nodes = []
    input.each.with_index do |l|
        nodes << Node.new(l*811589153)
    end
    nodes.each.with_index do |n,i|
        n.next_node = i == (nodes.count-1) ? nodes.first : nodes[i+1]
    end
    current_node = nodes[0]
    10.times do
        nodes.count.times do
            next_idx = (nodes.index(current_node) + current_node.value) % (nodes.count-1)
            nodes.delete(current_node)
            nodes.insert(next_idx, current_node)
            current_node = current_node.next_node
        end
    end

    final_map = nodes.map{|n| n.value}
    a = final_map[(final_map.index(0)+1000)%final_map.count]
    b = final_map[(final_map.index(0)+2000)%final_map.count]
    c = final_map[(final_map.index(0)+3000)%final_map.count]
    a + b + c
end

actual = File.read('./day20.txt').lines.map(&:to_i)
 
puts part1(actual)
puts part2(actual)

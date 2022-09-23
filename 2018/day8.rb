def processNode(node,depth)
    childCount, metadataCount = node.shift(2)
    if childCount == 0
        return node.shift(metadataCount).sum
    end
    total = 0
    childCount.times { total += processNode(node, depth+1) }
    return total + node.shift(metadataCount).sum
end

def part1(input)
    return processNode(input.split.map(&:to_i),0)
end

def processNode2(node, depth)
    childCount, metadataCount = node.shift(2)
    if childCount == 0
        return node.shift(metadataCount).sum
    end
    children = []
    childCount.times { children << processNode2(node, depth+1) }
    node.shift(metadataCount).map{|i|
        if i == 0 || i > children.count 
            0
        else
            children[i-1]
        end
    }.compact.sum
end

def part2(input)
    return processNode2(input.split.map(&:to_i),0)
end

actual = File.read('./day8.txt')

puts part1(actual)
puts part2(actual)

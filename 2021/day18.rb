$lastKey = 0
$letters = ("a".."z").to_a
def getNewKey
    newKey = $letters[$lastKey%26] * ($lastKey/26+1)
    $lastKey += 1
    return newKey
end

$nodes = {}

class Node
    attr_accessor :val, :left, :right, :parent

    def initialize(val, left, right, parent)
        @val, @left, @right, @parent = val, left, right, parent
    end

    def isLeaf
        return (@left.is_a? Numeric) && (@right.is_a? Numeric)
    end

    def reconstruct
        return "[" + ((@left.is_a? Numeric) ? @left.to_s : @left.reconstruct) + "," + ((@right.is_a? Numeric) ? @right.to_s : @right.reconstruct) + "]"
    end

    def magnitude
        return (3 * (@left.is_a?(Numeric) ? @left : @left.magnitude)) + (2 * (@right.is_a?(Numeric) ? @right : @right.magnitude))
    end

    def explode(left, leftVal, rightVal)
        if @left.is_a? Numeric
            @left += leftVal
        elsif !left
            @left.explodeDown(true, leftVal)
        else
            explodeUp(true, leftVal, @left.val)
        end
        if @right.is_a? Numeric
            @right += rightVal
        elsif left
            @right.explodeDown(false, rightVal)
        else
            explodeUp(false, rightVal, @right.val)
        end
        if left
            @left = 0
        else
            @right = 0
        end
    end

    def explodeUp(left, val, prevKey)
        if left
            if @left.is_a? Numeric
                @left += val
            elsif @left.val == prevKey
                if @parent != nil
                    $nodes[@parent].explodeUp(left, val, @val)
                end                
            else
                @left.explodeDown(left, val)
            end
        else
            if @right.is_a? Numeric
                @right += val
            elsif @right.val == prevKey
                if @parent != nil
                    $nodes[@parent].explodeUp(left, val, @val)
                end
            else
                @right.explodeDown(left, val)
            end
        end
    end

    def explodeDown(left, val)
        if left
            if @right.is_a? Numeric
                @right += val
            else
                @right.explodeDown(left, val)
            end
        else
            if @left.is_a? Numeric
                @left += val
            else
                @left.explodeDown(left, val)
            end
        end
    end
end

def reduce(node, left, depth, explode)
    if explode
        if node.isLeaf && depth == 4
            $nodes[node.parent].explode(left, node.left, node.right)
            return true
        else
            if !node.left.is_a? Numeric
                if reduce(node.left, true, depth + 1, true)
                    return true
                end
            end
            if !node.right.is_a? Numeric
                if reduce(node.right, false, depth + 1, true)
                    return true
                end
            end
            return false
        end
    else
        if node.left.is_a? Numeric
            if node.left > 9
                splitLeft = splitRight = node.left / 2
                splitRight += node.left % 2 == 0 ? 0 : 1
                newKey = getNewKey
                node.left = Node.new(newKey,splitLeft,splitRight,node.val)
                $nodes[newKey] = node.left
                return true
            end
        else
            if reduce(node.left, true, depth + 1, false)
                return true
            end
        end
        if node.right.is_a? Numeric
            if node.right > 9
                splitLeft = splitRight = node.right / 2
                splitRight += node.right % 2 == 0 ? 0 : 1
                newKey = getNewKey
                node.right = Node.new(newKey,splitLeft,splitRight,node.val)
                $nodes[newKey] = node.right
                return true
            end
        else
            if reduce(node.right, false, depth + 1, false)
                return true
            end
        end
        return false
    end
    return pairs
end

def getFishNodes(pairs, root, parent)
    left, right = pairs[root]
    left = left.match(/\D+/) ? getFishNodes(pairs,left,root) : left.to_i
    right = right.match(/\D+/) ? getFishNodes(pairs,right,root) : right.to_i
    $nodes[root] = Node.new(root,left,right,parent)
end

def parseFish(fish)
    pairs = {}
    while fish.include? "["
        fish.scan(/\[[0-9|a-z]+,[0-9|a-z]+\]/).each do |p|
            q = p[1...p.length-1]
            splits = q.split(",")
            key = getNewKey
            pairs[key] = splits
            fish.sub!(p, key)
        end
    end
    getFishNodes(pairs,fish,nil)
    reduced = true
    while reduced
        exploded = true
        while exploded
            exploded = reduce($nodes[fish], nil, 0, true)
        end
        reduced = reduce($nodes[fish], nil, 0, false)
    end
    return [$nodes[fish].reconstruct, $nodes[fish].magnitude]
end

def addFish(fish1, fish2)
    return "[" + fish1 + "," + fish2 + "]"
end

def part1(input)
    currentFish = input.shift.chomp
    magnitude = 0
    input.each do |nextFish|
        $nodes = {}
        $lastKey = 0
        currentFish = addFish(currentFish, nextFish.chomp)
        currentFish, magnitude = parseFish(currentFish)
    end
    return magnitude
end

def part2(input)
    mags = []
    for fish1Idx in 0...input.length-1
        for fish2Idx in  0...input.length-1
            if fish1Idx != fish2Idx
                $nodes = {}
                $lastKey = 0
                fish = addFish(input[fish1Idx].chomp, input[fish2Idx].chomp)
                mags << parseFish(fish)[1]
            end
        end
    end
    return mags.max
end

actual = File.open("day18.txt").readlines

puts part1(actual)
puts part2(actual)

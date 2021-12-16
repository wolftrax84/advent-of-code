class Node
    include Comparable

    attr_accessor :loc, :priority

    def initialize(loc, prio)
        @loc, @priority = loc, prio
    end

    def <=>(other)
        other == nil ? 1 : @priority <=> other.priority
    end
end

class PriorityQueue
    def initialize
        @queue = [nil]
    end

    def <<(newItem)
        @queue << newItem
        bubbleUp(@queue.length - 1)
    end

    def update(loc, newPriority)
        itemIdx = @queue.index {|node| node != nil && node.loc == loc}
        oldPriority = @queue[itemIdx].priority
        @queue[itemIdx].priority = newPriority
        if oldPriority < newPriority
            bubbleDown(itemIdx)
        else
            bubbleUp(itemIdx)
        end
    end

    def getPriority(loc)
        @queue[1...@queue.length].each do |node|
            if node.loc == loc
                return node.priority
            end
        end
        return 999999999
    end

    def bubbleUp(idx)
        parentIdx = idx/2
        if parentIdx < 1 || @queue[parentIdx] <= @queue[idx]
            return
        end
        @queue[parentIdx],@queue[idx] = @queue[idx],@queue[parentIdx]
        bubbleUp(parentIdx)
    end

    def bubbleDown(idx)
        childIdx = idx*2
        if childIdx > @queue.length - 1
            return
        end

        if childIdx < @queue.length - 1 && @queue[childIdx+1] < @queue[childIdx]
            childIdx += 1
        end

        if @queue[idx] < @queue[childIdx]
            return
        end

        @queue[idx], @queue[childIdx] = @queue[childIdx], @queue[idx]

        bubbleDown(childIdx)
    end
        

    def pop
        @queue[1], @queue[@queue.length-1] = @queue[@queue.length-1], @queue[1]
        max = @queue.pop
        bubbleDown(1)
        max
    end
end

def shortestPath(input)
    gridSize = input.length-1
    weights = {}
    visited = Hash.new()
    pinged = Hash.new()
    queue = PriorityQueue.new
    endLoc = [input.length-1, input.length-1]
    input.each.with_index {|line, row|
        line.chomp.chars.each.with_index {|c,col|
            visited[[row,col]] = false
            pinged[[row,col]] = false
            weights[[row,col]] = c.to_i
        }
    }
    queue << Node.new([0,0],0)
    loop do
        node = queue.pop
        loc, risk = node.loc, node.priority
        
        locsMap = {
            :up => [loc[0]-1,loc[1]],
            :down => [loc[0]+1,loc[1]],
            :left => [loc[0],loc[1]-1],
            :right => [loc[0],loc[1]+1]
        }

        if loc[0] > 0 && !visited[locsMap[:up]]
            if weights[locsMap[:up]] + risk < queue.getPriority(locsMap[:up])
                if pinged[locsMap[:up]]
                    queue.update(locsMap[:up], weights[locsMap[:up]] + risk)
                else
                    pinged[locsMap[:up]] = true
                    queue << Node.new(locsMap[:up], weights[locsMap[:up]] + risk)
                end
            end
        end
        if loc[0] < gridSize && !visited[locsMap[:down]]
            if weights[locsMap[:down]] + risk < queue.getPriority(locsMap[:down])
                if pinged[locsMap[:down]]
                    queue.update(locsMap[:down], weights[locsMap[:down]] + risk)
                else
                    pinged[locsMap[:down]] = true
                    queue << Node.new(locsMap[:down], weights[locsMap[:down]] + risk)
                end
            end
        end
        if loc[1] > 0 && !visited[locsMap[:left]]
            if weights[locsMap[:left]] + risk < queue.getPriority(locsMap[:left])
                if pinged[locsMap[:left]]
                    queue.update(locsMap[:left], weights[locsMap[:left]] + risk)
                else
                    pinged[locsMap[:left]] = true
                    queue << Node.new(locsMap[:left], weights[locsMap[:left]] + risk)
                end
            end
        end
        if loc[1] < gridSize && !visited[locsMap[:right]]
            if weights[locsMap[:right]] + risk < queue.getPriority(locsMap[:right])
                if pinged[locsMap[:right]]
                    queue.update(locsMap[:right], weights[locsMap[:right]] + risk)
                else
                    pinged[locsMap[:right]] = true
                    queue << Node.new(locsMap[:right], weights[locsMap[:right]] + risk)
                end
            end
        end
        visited[loc] = true
        if loc == endLoc
            return risk
        end
    end
end

def part1(input)
    return shortestPath(input)
end

def part2(input)
    expandedInput = ""
    input.each do |line|
        line.chomp!
        expandedLine = ""
        x = 0
        5.times do
            expandedLine += line.chars.map {|c| c.to_i + x > 9  ? c.to_i + x -9 : c.to_i + x }.join("")
            x += 1
        end
        expandedInput += expandedLine + "\n"
    end
    finalNew = expandedInput
    x = 1
    4.times do
        expandedInput.lines.each do |line|
            expandedLine = line.chomp.chars.map {|c| c.to_i + x > 9  ? c.to_i + x -9 : c.to_i + x }.join("")
            finalNew += expandedLine + "\n"
        end
        x += 1
    end
    return shortestPath(finalNew.lines)
end

actual = File.open("day15.txt").readlines

puts part1(actual)
puts part2(actual)

require_relative "priorityQueue"
include PriorityQueue

$proximityMaps = [{
    0 => [4],
    1 => [5],
    2 => [6],
    3 => [7],
    4 => [0,10],
    5 => [1,12],
    6 => [2,14],
    7 => [3,16],
    8 => [9],
    9 => [8,10],
    10 => [4,9,11],
    11 => [10,12],
    12 => [5,11,13],
    13 => [12,14],
    14 => [6,13,15],
    15 => [14,16],
    16 => [7,15,17],
    17 => [16,18],
    18 => [16]
},{
    0 => [4],
    1 => [5],
    2 => [6],
    3 => [7],
    4 => [0,8],
    5 => [1,9],
    6 => [2,10],
    7 => [3,11],
    8 => [4,12],
    9 => [5,13],
    10 => [6,14],
    11 => [7,15],
    12 => [8,18],
    13 => [9,20],
    14 => [10,22],
    15 => [11,24],
    16 => [17],
    17 => [16,18],
    18 => [12,17,19],
    19 => [18,20],
    20 => [13,19,21],
    21 => [20,22],
    22 => [14,21,23],
    23 => [22,24],
    24 => [15,23,25],
    25 => [24,26],
    26 => [25]
}]

def estimateCostToGoal(current,version)
    priority = 0
    offset = version == 1 ? 18 : 10
    current.each.with_index do |val,idx|
        if val != :_ && val != idx
            if val == idx-4 && current[val] == val
                next
            elsif version == 1 && val == idx-8 && current[val] == val && current[val+4] == val
                next
            elsif version == 1 && val == idx-12 && current[val] == val && current[val+4] == val && current[val+8] == val
                next
            else
                topOfCurrentRoom = idx%4 + offset + idx%4
                topOfTargetRoom = val + offset + val
                if idx > (version == 1 ? 15 : 7)
                    priority += ((topOfTargetRoom-idx).abs + 1) * (10**val)
                else
                    priority +=(((topOfCurrentRoom-topOfTargetRoom).abs + 1) * (10**val)) + ((topOfCurrentRoom - idx - offset + val) * (10**val))
                end
            end
        end
    end
    return priority
end
 
def roomClear(key, state, version)
    version0Clear = (state[key] == key || state[key] == :_) && (state[key+4] == key || state[key+4] == :_)
    if version == 1
        return version0Clear && (state[key+8] == key || state[key+8] == :_) && (state[key+12] == key || state[key+12] == :_)
    else
        return version0Clear
    end        
end

$invalidSpaces = [[10,12,14,16],[18,20,22,24]]
 
def getValidMoves(key, loc, state, version)
    if state[key] == key
        if loc == key + 4
            return []
        elsif version == 1
            if state[key+4] == key
                if loc == key + 8
                    return []
                elsif state[key+8] == key && loc == key + 12
                    return []
                end
            end
        end
    end
    moves = []
    checked = [loc]
    checkMoves = [*$proximityMaps[version][loc].select{|x| state[x] == :_}.map {|x| [x,1]}]
    while checkMoves.length > 0
        check = checkMoves.shift
        checked << check[0]
        if state[check[0]] == :_
            moves << check
            checkMoves.concat($proximityMaps[version][check[0]].select{|x| !checked.include?(x) && state[x] == :_}.map{|x| [x, check[1]+1]}).uniq!
        end
    end
    roomClear = roomClear(key,state,version)
    moves.select! {|m| !$invalidSpaces[version].include?(m[0]) && loc < 8*(version+1) ? m[0] >= 8*(version+1) : m[0] < 8*(version+1) && (m[0] == key || m[0]-4 == key || (version == 1 && m[0]-8 == key) || (version == 1 && m[0]-12 == key)) && roomClear}
    return moves
end

def getNeighbors(current,version)
    nextStates = []
    current.each.with_index do |val,loc|
        if val != :_ 
            validMoves = getValidMoves(val, loc, current, version)
            validMoves.each do |move|
                nxt = current.clone
                nxt[loc] = :_
                nxt[move[0]] = val
                nextStates << [nxt, move[1]*(10**val)]
            end
        end
    end
    return nextStates
end

def aStar(start,goal,version)
    pqueue = PrioQueue.new()
    startNode = PriorityQueueNode.new(start,0)
    pqueue << startNode
    costSoFar = {}
    costSoFar[start] = 0
    
    while pqueue.size != 0 do
        current = pqueue.pop
        if current.key == goal
            return costSoFar[current.key]
        end

        neighbors = getNeighbors(current.key, version)
        neighbors.each do |neighbor|
            newCost = costSoFar[current.key] + neighbor[1]
            if !costSoFar.has_key?(neighbor[0]) || newCost < costSoFar[neighbor[0]]
                costSoFar[neighbor[0]] = newCost
                newPrio = newCost + h(neighbor[0],version)
                pqueue << PriorityQueueNode.new(neighbor[0], newPrio)
            end
        end
    end
end


start = [3,0,1,1,3,0,2,2,:_,:_,:_,:_,:_,:_,:_,:_,:_,:_,:_]
goal = [0,1,2,3,0,1,2,3,:_,:_,:_,:_,:_,:_,:_,:_,:_,:_,:_]
puts aStar(start,goal,0)

start = [3,0,1,1,3,1,0,2,3,2,1,0,3,0,2,2,:_,:_,:_,:_,:_,:_,:_,:_,:_,:_,:_]
goal = [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,:_,:_,:_,:_,:_,:_,:_,:_,:_,:_,:_]
puts aStar(start,goal,1)

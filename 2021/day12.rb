$graph
$pathCount

def goDeeper(path)
    $graph[path.last].each do |nextNode|
        if nextNode == "start" || (nextNode == nextNode.downcase && path.any? {|e| nextNode == e })
            next
        elsif nextNode == "end"
            $pathCount += 1
        else
            goDeeper(path.clone << nextNode)
        end  
    end
end

def goDeeper2(path)
    $graph[path.last].each do |nextNode|
        if nextNode == "start"
            next
        elsif nextNode == "end"
            $pathCount += 1
            next
        elsif nextNode == nextNode.downcase && path.include?(nextNode)
            if path.tally.any? {|k,v| k.downcase == k && v == 2}
                next
            end
        end
        goDeeper2(path.clone << nextNode)
    end
end

def part1(input)
    $graph = Hash.new {|h,k| h[k] = []}
    $pathCount = 0
    input.map {|x| x.chomp.split(?-)}.each {
        $graph[_1] << _2
        $graph[_2] << _1
    }
    goDeeper(["start"])
    return $pathCount
end

def part2(input)
    $graph = Hash.new {|h,k| h[k] = []}
    $pathCount = 0
    input.map {|x| x.chomp.split(?-)}.each {
        $graph[_1] << _2
        $graph[_2] << _1
    }
    goDeeper2(["start"])
    return $pathCount
end

actual = File.open("./day12.txt").readlines

puts part1(actual)
puts part2(actual)

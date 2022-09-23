def parseInput(input)
    prio = Hash.new{|h,k| h[k] = []}
    blocked = []
    keys = []
    input.each do |l| 
        split = l.match(/Step ([A-Z]) must be finished before step ([A-Z]) can begin\./).captures
        prio[split[1]] << split[0]
        blocked << split[1]
        keys << split[0] 
        keys << split[1]
    end
    return [prio, keys, blocked]
end

def part1(input)
    prio, keys, blocked = parseInput(input)
    run_order = []
    active = keys.select{|k| !blocked.include?(k)}
    loop do
        next_task = active.shift
        run_order << next_task
        prio.delete(next_task)
        prio.each {|k,v| v.delete(next_task)}
        active.concat(prio.select {|k,v| v.count == 0}.map{|k,v| k}).sort!.uniq!
        if active.count == 0
            return run_order.join('')
        end
    end
end

def part2(input)
    prio, keys, blocked = parseInput(input)
    active = keys.select{|k| !blocked.include?(k)}.sort!.uniq!
    workers = []
    timer = 0
    loop do
        workers.each do |w|
            if w[1] == 1
                prio.each {|k,v| v.delete(w[0])}
                active.concat(prio.select {|k,v| v.count == 0}.map{|k,v| k}).sort!.uniq!
            end
            w[1] -= 1
        end
        workers.select! {|w| w[1] != 0}
        while active.count > 0 && workers.count < 5
            next_task = active.shift
            prio.delete(next_task)
            workers << [next_task, 61+(("A".."Z").to_a().index(next_task))]
        end
        if workers.count == 0
            return timer
        end
        timer += 1
    end
end

actual = File.read('./day7.txt').lines

puts part1(actual)
puts part2(actual)

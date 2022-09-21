def parseInput(input)
    schedule = Hash.new {|hash,key| hash[key] = Hash.new(0)}
    totals = Hash.new(0)
    lines = input.map {|l| l.match(/\[\d{4}-(\d{2})-(\d{2}) (00|23):(\d{2})\] (falls|wakes|Guard) (?>asleep|up|#(\d+))(?> begins shift)*/).captures}
    lines.sort! { |a,b| [a[0].to_i,a[1].to_i,a[2].to_i,a[3].to_i] <=> [b[0].to_i,b[1].to_i,b[2].to_i,b[3].to_i]}
    current_guard = -1
    current_sleep = -1
    lines.each do |l|
        if l[4] == "Guard"
            current_guard = l[5]
        elsif l[4] == "falls"
            current_sleep = l[3].to_i
        else
            minutes_asleep = *(current_sleep...l[3].to_i)
            minutes_asleep.each {|m| schedule[current_guard][m] += 1}
            totals[current_guard] += l[3].to_i - current_sleep
        end
    end
    return [schedule, totals]
end

def part1(input)
    schedule, totals = parseInput(input)
    max_guard = totals.max_by {|k,v| v}[0]
    max_minute = schedule[max_guard].max_by {|k,v| v}[0]
    return max_minute.to_i * max_guard.to_i
end

def part2(input)
    schedule, totals = parseInput(input)
    max_minutes = schedule.map {|k,v| [k,v.max_by {|k2,v2| v2}]}
    max = max_minutes.max_by { |g| g[1][1] }
    return max[0].to_i * max[1][0]
end

actual = File.read('./day4.txt').lines

puts part1(actual)
puts part2(actual)

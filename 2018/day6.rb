def part1(input)
    points = {}
    input.each_with_index {|p,i| points[i] = p.split(',').map(&:to_i)}
    top_edge, bottom_edge = points.minmax_by {|k,p| p[1]}.map! {|c| c[1][1]}
    left_edge, right_edge = points.minmax_by {|k,p| p[0]}.map! {|c| c[1][0]} 
    totals = Hash.new(0)
    edge_hits = []
    (left_edge..right_edge).to_a().product((top_edge..bottom_edge).to_a()).each do |(row,col)|
        dists = points.map do |k,p| 
            (p[1]-row).abs()+(p[0]-col).abs()
        end
        min_dist = dists.tally().min_by {|k,v| k}
        next if min_dist[1] > 1
        closest_point = dists.index(min_dist[0])
        totals[closest_point] += 1
        if row == top_edge || row == bottom_edge || col == left_edge || col == right_edge
            edge_hits << closest_point
        end
    end
    return totals.select! {|k,v| !edge_hits.include?(k)}.max_by {|k,v| v}[1]
end

def part2(input, range)
    points = {}
    input.each_with_index {|p,i| points[i] = p.split(',').map(&:to_i)}
    top_edge, bottom_edge = points.minmax_by {|k,p| p[1]}.map! {|c| c[1][1]}
    left_edge, right_edge = points.minmax_by {|k,p| p[0]}.map! {|c| c[1][0]} 
    return (left_edge..right_edge).to_a().product((top_edge..bottom_edge).to_a()).count do |c|
        points.sum {|k,p| (p[1]-c[1]).abs()+(p[0]-c[0]).abs()} < range
    end
end

actual = File.read('./day6.txt').lines

puts part1(actual)
puts part2(actual, 10000)

def part1(input)
    # Map input from 'LxWxD' to ascending sorted array [L,W,D]
    mapped_input = input.map {|line| line.split('x').map(&:to_i).sort}

    # Map sorted dimensions to calculated wrapping paper size
    paper_sizes = mapped_input.map { |line| line.combination(2).map{|c| c.inject(:*)*2}.sum + (line[0]*line[1])}

    # Return total of all paper sizes
    return paper_sizes.sum
end

def part2(input)
    # Map input from 'LxWxD' to ascending sorted array [L,W,D]
    mapped_input = input.map {|line| line.split('x').map(&:to_i).sort}

    # Map sorted dimensions to calculated ribbon length
    ribbon_lengths = mapped_input.map {|line| line.inject(:*) + line[0]*2+line[1]*2}

    # Return total of all ribbon lengths
    return ribbon_lengths.sum
end

actual = File.read("./day2.txt").lines

puts part1(actual)
puts part2(actual)

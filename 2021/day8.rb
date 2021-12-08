def part1(input)
    return input.map {|l| l.split(?|)[1].split(" ").count {|x| x.length != 5 && x.length != 6 } }.sum
end

def part2(input)
    return input.map {|line| 
        i, o = line.split(?|).map(&:strip).map {|x| x.split(" ")}
        i.map! {|x| x.split("")}
        segments = {}
        # Process "1"
        segments[2] = segments[5] = i.find {|x| x.length == 2}
        # Process "7"
        segments[0] = i.find {|x| x.length == 3}.find {|c| !segments[2].include?(c)}
        # Process "4"
        segments[3] = segments[1] = i.find {|x| x.length == 4}.filter {|c| !segments[2].include?(c)}
        # Process "6"
        six = i.find {|x| x.length == 6 && x.count {|c| segments[2].include?(c)} == 1}
        segments[5] = six.find {|c| segments[2].include?(c)}[0]
        # Disambiguate segment 2
        segments[2] = segments[2][segments[2][0] == segments[5] ? 1 : 0]
        # Add segments 4 and 6
        segments[4] = segments[6] = six.filter {|c| !segments[0].include?(c) && !segments[2].include?(c) && !segments[5].include?(c) && !segments[1].include?(c)}
        # Process "0"
        segments[3] = segments[3].find {|j| !(i.find {|x| x.length == 6 && x.filter {|c| segments[1].include?(c) || segments[3].include?(c)}.length == 1}).include?(j)}
        # Disambiguate segment 1
        segments[1] = segments[1][segments[1][0] == segments[3] ? 1 : 0]
        # Process "9"
        segments[4] = segments[4].find {|j| !(i.find {|x| x.length == 6 && x.filter {|c| segments[4].include?(c) || segments[6].include?(c)}.length == 1}).include?(j)}
        # Disambiguate segment 6
        segments[6] = segments[6][segments[6][0] == segments[4] ? 1 : 0]

        decodedStrings = [
            segments[0]+segments[1]+segments[2]+segments[4]+segments[5]+segments[6],
            segments[2]+segments[5],
            segments[0]+segments[2]+segments[3]+segments[4]+segments[6],
            segments[0]+segments[2]+segments[3]+segments[5]+segments[6],
            segments[1]+segments[2]+segments[3]+segments[5],
            segments[0]+segments[1]+segments[3]+segments[5]+segments[6],
            segments[0]+segments[1]+segments[3]+segments[4]+segments[5]+segments[6],
            segments[0]+segments[2]+segments[5],
            "abcdefg",
            segments[0]+segments[1]+segments[2]+segments[3]+segments[5]+segments[6]
        ].map {|d| d.split("").sort!.join("")}

        o.map {|z| decodedStrings.index(z.split("").sort!.join(""))}.join("").to_i
    }.sum
end

actual = File.open("day8.txt").readlines

puts part1(actual)
puts part2(actual)

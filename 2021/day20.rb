$algo = []

def getNewPixel(image, loc, flipped)
    idx = ""
    if loc[0] <= 0
        idx << flipped * 3
    else
        idx += loc[1] > 0 ? image[loc[0]-1][loc[1]-1] : flipped
        idx += loc[1] >= 0 && loc[1] < image.length ? image[loc[0]-1][loc[1]] : flipped
        idx += loc[1] < image.length-1 ? image[loc[0]-1][loc[1]+1] : flipped
    end

    if loc[0] == -1 || loc[0] == image.length
        idx << flipped * 3
    else
        idx += loc[1] > 0 ? image[loc[0]][loc[1]-1] : flipped
        idx += loc[1] >= 0 && loc[1] < image.length ? image[loc[0]][loc[1]] : flipped
        idx += loc[1] < image.length-1 ? image[loc[0]][loc[1]+1] : flipped
    end

    if loc[0] >= image.length-1
        idx << flipped * 3
    else
        idx += loc[1] > 0 ? image[loc[0]+1][loc[1]-1] : flipped
        idx += loc[1] >= 0 && loc[1] < image.length ? image[loc[0]+1][loc[1]] : flipped
        idx += loc[1] < image.length-1 ? image[loc[0]+1][loc[1]+1] : flipped
    end
    return $algo[idx.to_i(2)]
end

def enhance(image, count)
    count.times do |i|
        nextImage = []
        for row in -1..image.length
            nextRow = []
            for col in -1..image.length
                nextRow << getNewPixel(image,[row,col], i % 2 == 1 ? $algo[0] : "0" )
            end
            nextImage << nextRow
        end
        image = nextImage
    end
    return image
end

def part1(input)
    algo, image = input.split("\n\n")
    $algo = algo.chars.map {|c| c == "#" ? "1" : "0"}
    image = image.lines.map {|l| l.chomp.chars.map {|c| c == "#" ? "1" : "0"}}

    return enhance(image,2).flatten.count("1")
end

def part2(input)
    algo, image = input.split("\n\n")
    $algo = algo.chars.map {|c| c == "#" ? "1" : "0"}
    image = image.lines.map {|l| l.chomp.chars.map {|c| c == "#" ? "1" : "0"}}

    return enhance(image,50).flatten.count("1")
end


actual = File.open("day20.txt").read

puts part1(actual)
puts part2(actual)

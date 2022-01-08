def part1(input)
    h = input.length
    w = input[0].chomp.length

    easts = []
    souths = []

    input.each.with_index do |r,ridx|
        r.chomp.chars.each.with_index do |c,cidx|
            if c == ">"
                easts << [ridx,cidx]
            elsif c == "v"
                souths << [ridx,cidx]
            end
        end
    end

    grid = input.map do |line|
        line.chomp.chars
    end

    iters = 1
    loop do
        moves = 0
        (0...(grid.length)).each do |x|
            (0...(grid[0].length)).each do |y|
                if grid[x][y]  == ">" && grid[x][(y+1) % w] == "."
                    moves += 1
                    grid[x][y] = "o"
                    grid[x][(y+1) % w] = "x"
                end
            end
        end
        grid.map! {|l| l.map! {|c| c == "x" ? ">" : c=="o" ? "." : c}}
        (0...grid.length).each do |x|
            (0...grid[0].length).each do |y|
                if grid[x][y]  == "v" && grid[(x+1) % h][y] == "."
                    moves += 1
                    grid[x][y] = "o"
                    grid[(x+1)%h][y] = "x"
                end
            end
        end
        grid.map! {|l| l.map! {|c| c == "x" ? "v" : c=="o" ? "." : c}}
        if moves == 0
            break
        end
        iters += 1
    end
    return iters
end

actual = File.open("day25.txt").readlines

puts part1(actual)
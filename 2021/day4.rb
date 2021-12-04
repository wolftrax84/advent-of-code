def part1(input)
    draws = input[0].split(",").map(&:to_i)
    boards = []
    for x in 0..(input.length-2)/6
        board = []
        for y in 0...5
            board << input[2+(x*6)+y].split(" ").map(&:to_i)
        end
        boards << board
    end

    drawn = []
    for draw in draws 
        drawn << draw
        boards.each.with_index {|board, idx|
            for line in board
                if (line.count {|i| drawn.include?(i)} == 5)
                    return boards[winner].flatten.filter!{|x| !drawn.include?(x)}.sum * drawn.last
                end
            end
            for z in 0...board[0].length
                if (board.count {|l| drawn.include?(l[z])} == 5)
                    return boards[idx].flatten.filter!{|x| !drawn.include?(x)}.sum * drawn.last
                end
            end
        }
    end
end

def part2(input)
    draws = input[0].split(",").map(&:to_i)
    boards = []
    for x in 0..(input.length-2)/6
        board = []
        for y in 0...5
            board << input[2+(x*6)+y].split(" ").map(&:to_i)
        end
        boards << board
    end
    drawn = []
    winners = []
    while winners.length != boards.length
        drawn << draws.shift
        boards.each.with_index {|board, idx|
            if winners.include?(idx)
                next
            end
            if board.any? {|l| l.count{ |i| drawn.include?(i)} == 5} || (0...board[0].length).any? {|col| board.count {|l| drawn.include?(l[col])} == 5}
                winners << idx
            end
        }
    end
    return boards[winners.last].flatten.filter!{|x| !drawn.include?(x)}.sum * drawn.last
end

actual = File.open("day4.txt").readlines

puts part1(actual)
puts part2(actual)

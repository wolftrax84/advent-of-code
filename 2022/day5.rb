def part1(board, moves)
    moves.each do |m|
        caps = m.match(/move (\d+) from (\d+) to (\d+)/).captures.map(&:to_i)
        board[caps[2]-1].unshift(*board[caps[1]-1].shift(caps[0]).reverse)
    end
    return board.map{|a| a[0]}.join
end

def part2(board, moves)
    moves.each do |m|
        caps = m.match(/move (\d+) from (\d+) to (\d+)/).captures.map(&:to_i)
        board[caps[2]-1].unshift(*board[caps[1]-1].shift(caps[0]))
    end
    return board.map{|a| a[0]}.join
end

actual = File.read('./day5.txt')

board_lines, moves = actual.split(/\n\n/).map(&:lines)
board1 = []
board2 = []
board_lines[0..(-2)].each do |board_line|
    board_line.chars.each_slice(4).map(&:join).map(&:strip).map.with_index do |space, crate|
        next if space == ""
        (board1[crate] ||= []) << space[1]
        (board2[crate] ||= []) << space[1]
    end
end

puts part1(board1, moves)
puts part2(board2, moves)

def part1(input)
    positions = input.map {|l| l.chomp.chars.last.to_i}
    scores = [0,0]
    player = 0
    iters = 0
    while scores.max < 1000
        die = (iters+1) % 100 == 0 ? 100 : (iters+1) % 100
        positions[player] = (positions[player] + (die * 3) + 3) % 10 == 0 ? 10 : (positions[player] + (die * 3) + 3) % 10
        scores[player] += positions[player]
        player = player == 0 ? 1 : 0
        iters += 3
    end
    return scores.min * iters
end

$cache = {}
$dieRolls = [1,2,3,1,2,3,1,2,3].permutation(3).to_a.uniq.map(&:sum).tally

def run(scores,positions,player)
    if $cache[[scores,positions,player]]
        return $cache[[scores,positions,player]]
    end
    wins = [0,0]
    $dieRolls.keys.each do |d|
        newPositions = *positions
        newPositions[player] = (positions[player] + d) % 10 == 0 ? 10 : (positions[player] + d) % 10
        newScores = *scores
        newScores[player] += newPositions[player]
        if newScores[player] >= 21
            wins[player] += $dieRolls[d]
        else
            newWins = run(newScores,newPositions,player == 0 ? 1 : 0).map {|w| w*$dieRolls[d]}
            wins = [wins,newWins].transpose.map(&:sum)
        end 
    end
    $cache[[scores,positions,player]] = wins
    return wins
end

def part2(input)
    positions = input.map {|l| l.chomp.chars.last.to_i}
    return run([0,0],positions,0).max
end

actual = File.open("day21.txt").readlines

puts part1(actual)
puts part2(actual)

require 'set'

class Actor
  def initialize(type, position)
    set_position(position)
    @type = type
    @hp = 200
    @attack = 3
  end

  attr_accessor :type, :position, :hp, :attack, :neighbors

  def set_position(new_position)
    @position = new_position
    @neighbors = [[new_position[0]-1,new_position[1]], [new_position[0],new_position[1]-1], [new_position[0],new_position[1]+1], [new_position[0]+1, new_position[1]]]
  end

end

def shortest_path(map, start, targets)
  queue = {}
  queue[start] = 0
  visited = Set[]
  targets_hit = 0
  loop do
    loc, dist = queue.min_by { |k, v| [v, k[0], k[1]] }
    visited.add(loc)
    queue.delete(loc)
    if targets.has_key?(loc)
      targets[loc] = [targets[loc], dist].min
      targets_hit += 1
      return targets if targets_hit == targets.size
    end
    # p loc
    neighbors = [[loc[0]-1,loc[1]], [loc[0],loc[1]-1], [loc[0],loc[1]+1], [loc[0]+1, loc[1]]]
    neighbors.each do |n|
      next if visited.include?(n) || map[n[0]][n[1]] != '.'
      queue[n] = [(queue[n] || Float::INFINITY), dist+1].min
      # p queue[n]
    end
    break if queue.size == 0
  end
  targets
end

def part1(input)
  map = []
  elves = []
  goblins = []
  actors = []
  goblin_targets = Set[]
  elf_targets = Set[]
  input.each.with_index do |l, row|
    map << l.chomp.chars
    map[-1].each.with_index do |c, col|
      if c == 'G'
        goblin = Actor.new(c, [row, col])
        goblins << goblin
        goblin_targets.merge(goblin.neighbors)
        actors << goblin
      elsif c == 'E'
        elf = Actor.new(c, [row, col])
        elves << elf
        elf_targets.merge(elf.neighbors)
        actors << elf
      end
    end
  end
  
  i = 1
  
  loop do
    if i == 36
      p "i'm in round #{i}!"
      p actors
      p elves
    end
    actors.each.with_index do |actor, idx|
      if i == 75
        p actor
      end
      next if actor.hp <= 0
      targets = {
        [actor.position[0]-1, actor.position[1]] => Float::INFINITY, 
        [actor.position[0], actor.position[1]-1] => Float::INFINITY, 
        [actor.position[0], actor.position[1]+1] => Float::INFINITY,
        [actor.position[0]+1, actor.position[1]] => Float::INFINITY
      }
      
      #MOVE
      # test if in position
      if targets.none? { |loc, dist| map[loc[0]][loc[1]] == (actor.type == 'E' ? 'G' : 'E') }      
        # remove any blocked spaces
        targets.select!{|loc, dist| map[loc[0]][loc[1]] == '.'}
        
        if targets.size != 0
          # find space nearest an enemy
          enemies = actor.type == 'E' ? goblins : elves
          enemies.each do |enemy|
            [[enemy.position[0]-1, enemy.position[1]], 
            [enemy.position[0], enemy.position[1]-1], 
              [enemy.position[0], enemy.position[1]+1],
              [enemy.position[0]+1, enemy.position[1]]
            ].select {|source| map[source[0]][source[1]] == '.'}.each { |source|
              shortest_path(map, source, targets)
            }
          end
          # p targets
          # update actor position and map
          newLoc, dist = targets.min_by { |k, v| [v, k[0], k[1]] }
          if dist == Float::INFINITY
            # p "no moves for #{actor.position}"
            next
          end
          map[actor.position[0]][actor.position[1]] = '.'
          # p newLoc
          map[newLoc[0]][newLoc[1]] = actor.type
          actor.position = newLoc
        end
      end
      
      # ATTACK
      targets = {
        [actor.position[0]-1, actor.position[1]] => Float::INFINITY, 
        [actor.position[0], actor.position[1]-1] => Float::INFINITY, 
        [actor.position[0], actor.position[1]+1] => Float::INFINITY,
        [actor.position[0]+1, actor.position[1]] => Float::INFINITY
      }
      if targets.any? { |loc, dist| map[loc[0]][loc[1]] == (actor.type == 'E' ? 'G' : 'E') }
        attackTarget = targets.map {|loc, dist| actors.find {|a| a.position == loc && a.type != actor.type}}.compact.min_by {|a| [a.hp, *a.position]}
        attackTarget.hp -= actor.attack
        if attackTarget.hp <= 0
          map[attackTarget.position[0]][attackTarget.position[1]] = '.'
        end
      end
      elves.select! {|a| a.hp > 0}
      goblins.select! {|a| a.hp > 0}
      if elves.size == 0 || goblins.size == 0
        p actors.select{ |a| a.hp > 0 }.map {|a| [a.type, a.position, a.hp]}
        p actors.select{ |a| a.hp > 0 }.map {|a| a.hp}.sum
        p (idx == actors.size - 1 ? i : i-1)
        return actors.select{ |a| a.hp > 0 }.map {|a| a.hp}.sum * (idx == actors.size - 1 ? i : i-1)
      end
    end    
    
    actors.select! {|a| a.hp > 0}
    actors.sort_by! {|actor| actor.position}
    p "round #{i}"
    i+= 1
    p actors.map {|a| [a.type, a.position, a.hp]}
  end
  # p ""
  'end'
end

def part2(input); end

actual = File.read('./day15.txt').lines

movement_test = '#######
#E..G.#
#...#.#
#.G.#G#
#######'.lines

movement_test_2 = '#########
#G..G..G#
#.......#
#.......#
#G..E..G#
#.......#
#.......#
#G..G..G#
#########'.lines

movement_test_3 =  '#########
#..G.G..#
#...G...#
#.G.E.G.#
#.......#
#G..G..G#
#.......#
#.......#
#########'.lines

combat_test = '#######   
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######'.lines

combat_test_2 = '#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######'.lines

combat_test_3 = '#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######'.lines

combat_test_4 = '#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######'.lines

combat_test_5 = '#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######'.lines

combat_test_6 = '#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########'.lines

# puts [27730, part1(combat_test)]
# puts [36334, part1(combat_test_2)]
# puts [39514, part1(combat_test_3)]
# puts [27755, part1(combat_test_4)]
# puts [28944, part1(combat_test_5)]
# puts [18740, part1(combat_test_6)]
# puts part1(actual)

# too low 181300
# 183750
# too high 184200
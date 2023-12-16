def hash(string)
  value = 0
  string.each_byte { |c|
    value += c
    value *= 17
    value = value % 256
  }
  value
end

def part1(input)
  input.split(",").map { |op|
    hash(op)
  }.sum
end

def part2(input)
  boxes = {}
  input.split(",").each { |instruction|
    label, op, val = instruction.match(/([a-z]+)(=|-)(\d*)/).captures.to_a
    label_hash = hash(label)
    case op
    when "="
      if !boxes.include?(label_hash)
        boxes[label_hash] = [[label, val.to_i]]
      else
        idx = boxes[label_hash].index { |e| e[0] == label }
        if idx
          boxes[label_hash][idx] = [label, val.to_i]
        else
          boxes[label_hash] << [label, val.to_i]
        end
      end
    when "-"
      if boxes.include?(label_hash)
        boxes[label_hash].delete_if { |e| e[0] == label }
      end
    end
  }
  power = 0
  boxes.each { |k, v|
    power += v.map.with_index { |lens, index|
      (k + 1) * (index + 1) * lens[1]
    }.sum
  }
  power
end

actual = File.read("./day15.txt").chomp

puts part1(actual)
puts part2(actual)

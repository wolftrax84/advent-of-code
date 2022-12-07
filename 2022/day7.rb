$sizes = {}

def getDirSize(tree, dir)
    if $sizes.include? dir
        $sizes[dir]
    end
    sum = 0
    tree[dir].each do |thing|
        if thing.is_a? Integer
            sum += thing
        else
            sum += getDirSize(tree, thing)
        end
    end
    $sizes[dir] = sum
    sum
end

def part1(sizes)
    return sizes.filter{|s| s <= 100000}.sum
end

def part2(sizes)
    needed = 30000000 - (70000000 - sizes.max)
    return sizes.filter{|x| x >= needed}.min
end

actual = File.read('./day7.txt').lines

tree = Hash.new { |h, k| h[k] = [] }
directory = ['root']
actual.each do |l|
    pieces = l.split
    case(pieces[0])
    when "$"
        case pieces[1]
        when "cd"
            case pieces[2]
            when "/"
                next
            when ".."
                directory.pop
            else
                directory << pieces[2]
                tree[directory.join("|")] = []
            end
        end
    when "dir"
        tree[directory.join("|")] << "#{directory.join("|")}|#{pieces[1]}"
    else
        tree[directory.join("|")] << pieces[0].to_i
    end
end

getDirSize(tree, "root")

puts part1($sizes.values)
puts part2($sizes.values)

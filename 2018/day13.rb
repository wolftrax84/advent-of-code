class Cart
    def initialize id, loc, dir
        @id = id
        @location = loc
        @direction = dir
        @turn = :left
        @alive = true
    end
    attr_reader :id
    attr_accessor :location
    attr_accessor :turn
    attr_accessor :alive

    def move map
        case @direction
        when :left
            @location[0] -= 1
            case map[@location]
            when "/"
                @direction = :down
            when "\\"
                @direction = :up
            when "+"
                turn
            end
        when :right
            @location[0] += 1
            case map[@location]
            when "/"
                @direction = :up
            when "\\"
                @direction = :down
            when "+"
                turn
            end
        when :down
            @location[1] += 1
            case map[@location]
            when "/"
                @direction = :left
            when "\\"
                @direction = :right
            when "+"
                turn
            end
        when :up
            @location[1] -= 1
            case map[@location]
            when "/"
                @direction = :right
            when "\\"
                @direction = :left
            when "+"
                turn
            end
        end
    end

    def turn
        case @turn
        when :left
            case @direction
            when :left
                @direction = :down
            when :right
                @direction = :up
            when :up
                @direction = :left
            when :down
                @direction = :right
            end
            @turn = :straight
        when :straight
            @turn = :right
        when :right
            case @direction
            when :left
                @direction = :up
            when :right
                @direction = :down
            when :up
                @direction = :right
            when :down
                @direction = :left
            end
            @turn = :left
        end
    end
end

def part1(map, carts)
    loop do
        carts.sort_by!{|c| [c.location[1],c.location[0]]}
        carts.each do |cart|
            cart.move(map)
            cart_locs = carts.map {|cart| cart.location}.tally
            if cart_locs.value?(2)
                return "#{cart_locs.keys.select {|loc| cart_locs[loc] == 2}[0]}"
            end
        end
    end
end

def part2(map, carts)
    loop do
        carts.sort_by!{|c| [c.location[1],c.location[0]]}
        carts.each do |cart|
            next if !cart.alive
            cart.move(map)
            crashed_cart = carts.find{|c| c.location == cart.location && c.id != cart.id && c.alive}
            if crashed_cart
                cart.alive = false
                crashed_cart.alive = false
            end
        end
        alive_carts = carts.select{|cart| cart.alive}
        if alive_carts.count == 1
            return "#{alive_carts[0].location}"
        end
    end
end

actual = File.read('./day13.txt').lines

run = actual
ids = 0
carts = []
carts2 = []
map = {}
run.each.with_index do |line, row|
    line.chars.each.with_index do |loc, col|
        next if loc == " "
        if [">","<","^","v"].include?(loc)
            map[[col,row]] = loc == ">" ? "-" : "|"
            carts.push(Cart.new(ids,[col,row], loc == ">" ? :right : loc == "<" ? :left : loc == "v" ? :down : :up ))
            carts2.push(Cart.new(ids,[col,row], loc == ">" ? :right : loc == "<" ? :left : loc == "v" ? :down : :up ))
            ids += 1
        else
            map[[col,row]] = loc
        end
        map[[col,row]] = loc
    end
end


puts part1(map, carts)
puts part2(map, carts2)

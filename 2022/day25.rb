def part1(input)
    places = Array.new
    input.each do |l|
        l.chomp.chars.reverse.map{|c| (c == "=") ? -2 : (c == "-") ? -1 : c.to_i }.each.with_index do |c,i|
            (i >= places.count) ? places[i] = [c] : places[i] << c
        end
    end
    carry = 0
    digits = places.map do |d|
        updated = d.sum + carry
        carry = updated/5
        updated - (carry*5)
    end
    carry = 0
    finals = digits.map.with_index do |d,i|
        d = d + carry
        carry = d / 3
        (d < 3) ? d : d - 5
    end
    finals.reverse.map {|d| (d == -2) ? "=" : (d == -1) ? "-" : d.to_s}.join
end

actual = File.read('./day25.txt').lines

puts part1(actual)

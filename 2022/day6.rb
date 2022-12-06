def func(line, size)
    line.chars.each_cons(size).with_index do |x,i|
        return (i+size) if x.uniq.count == size
    end
end

actual = File.read('./day6.txt').chomp

puts func(actual, 4)
puts func(actual, 14)

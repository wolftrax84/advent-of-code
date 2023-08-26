# Use the md5 package calculate hashes
require 'digest/md5'

def part1(input)
    # Loop and increment i until result found
    loop.with_index do |_,i|
        # Calculate hash from salt and i
        hash = Digest::MD5.hexdigest("#{input}#{i}")
        # Return index if hash matches requirement
        return i if hash.start_with?('00000')
    end
end

def part2(input)
    # Loop and increment i until result found
    loop.with_index do |_,i|
        # Calculate hash from salt and i
        hash = Digest::MD5.hexdigest("#{input}#{i}")
        # Return index if hash matches requirement
        return i if hash.start_with?('000000')
    end
end

actual = "iwrupvqb"

puts part1(actual)
puts part2(actual)

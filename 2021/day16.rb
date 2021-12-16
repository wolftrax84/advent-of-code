def processPacket(binary, idx, subpacket)
    version_sum = binary[idx..idx+2].to_i(2)
    idx += 3
    type = binary[idx..idx+2].to_i(2)
    idx += 3
    value = 0
    case (type)
    when 4
        literal = ""
        while binary[idx] != "0"
            literal += binary[idx+1..idx+4]
            idx += 5
        end
        literal += binary[idx+1..idx+4]
        idx += 5
        value = literal.to_i(2)
    else
        length_type = binary[idx]
        idx += 1
        sub_values = []
        case length_type
        when "0"
            subpacket_bits_count = binary[idx..idx+14].to_i(2)
            idx += 15
            endIdx = idx + subpacket_bits_count
            while idx < endIdx
                subversion_sum, idx, subvalue = processPacket(binary,idx,true)
                version_sum += subversion_sum
                sub_values << subvalue
            end
        when "1"
            subpacket_count = binary[idx..idx+10].to_i(2)
            idx += 11
            subpacket_count.times do |x|
                subversion_sum, idx, subvalue = processPacket(binary,idx,true)
                version_sum += subversion_sum
                sub_values << subvalue
            end
        end
        case type
        when 0
            value = sub_values.sum
        when 1
            value = sub_values.inject(:*)
        when 2
            value = sub_values.min
        when 3
            value = sub_values.max
        when 5
            value = sub_values[0] > sub_values[1] ? 1 : 0
        when 6
            value = sub_values[0] < sub_values[1] ? 1 : 0
        when 7
            value = sub_values[0] == sub_values[1] ? 1 : 0
        end
    end
    if !subpacket
        while idx % 4 != 0
            idx += 1
        end
    end
    return [version_sum,idx,value]
end

def part1(input)
    binary = input.chars.map {|c| c.to_i(16).to_s(2).rjust(4,"0")}.join("")
    version_sum, idx, value = processPacket(binary,0,false)
    return version_sum
end

def part2(input)
    binary = input.chars.map {|c| c.to_i(16).to_s(2).rjust(4,"0")}.join("")
    version_sum, idx, value = processPacket(binary,0,false)
    return value

end

actual = File.open("day16.txt").read

puts part1(actual)
puts part2(actual)

$a = []
$b = []
$d = []

def calcZ(w,i,prevZ)
    if prevZ%26+$a[i] != w
        prevZ / $d[i] * 26 + w + $b[i]
    else
        prevZ / $d[i]
    end
end

def run(input)
    (0..13).each do |x|
        $d << input[x*18 + 4].split()[2].to_i
        $a << input[x*18 + 5].split()[2].to_i
        $b << input[x*18 + 15].split()[2].to_i
    end

    zMap = {0 => [0,0]}

    (0..13).each do |i|
        tempZ = {}
        zMap.each do |prevZ,vals|
            (1..9).each do |w|
                z = calcZ(w,i,prevZ)
                if $d[i] == 1 || ($d[i] == 26 && z < prevZ)
                    if tempZ[z] != nil
                        tempZ[z] = [[tempZ[z][0],zMap[prevZ][0]*10+w].min,[tempZ[z][1],zMap[prevZ][1]*10+w].max]
                    else
                        tempZ[z] = [zMap[prevZ][0]*10+w,zMap[prevZ][1]*10+w]
                    end
                end
                
            end
        end
        zMap = tempZ
    end
    return zMap[0]
end

actual = File.open("day24.txt").readlines

puts run(actual)

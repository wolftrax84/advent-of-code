$year=$args[0]
write-host Building Advent of Code Directory for: $year

function makeDirectory {
    param (
        $path
    )

    if(Test-Path $path) { 
        write-host Directory $path already exists.
    }
    else {
        New-Item -Path $path -ItemType Directory
    }
}

function makeFile {
    param (
        $path,
        $content = $null
    )

    if(Test-Path $path -PathType Leaf) { 
        write-host File $path already exists.
    }
    else {
        New-Item -Path $path -ItemType File
        if ($content) {
            $content | Out-File -FilePath $path -encoding ASCII
        }
    }
}

$path = '.\'+$year;
makeDirectory -path $path

################################################
# Create day files
################################################
$dayFileContent = 

for($i=1; $i -le 25; $i++) {
    $dayPath = $path + "\day$i.rb"
    makeFile -path $dayPath -content "def part1(input)

end

def part2(input)

end

actual = File.read('./day$i.txt').lines

puts part1(actual)
puts part2(actual)"
}

Set-Location $path
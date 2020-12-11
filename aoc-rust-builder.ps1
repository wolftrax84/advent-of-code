$year=$args[0]
write-host Building Advent of Code Directory for: $year
$rootPath = '.\'+$year;

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
        # New-Item -Path $path -ItemType File
        if ($content) {
            write-output $content | Out-File -FilePath $path -encoding ASCII
        }
    }
}

makeDirectory -path $rootPath

function makeCargoConfig {
    param (
        $projectName,
        $path
    )
    $content = '[package]
name = "'+$projectName+'"
version = "0.2.0"
authors = ["Sean Owens <seangabrielowens@gmail.com>"]
edition = "2018"

[dependencies]
aoc_rust_common = { path =  "../../../aoc_rust_common"}
'

    makeFile -path ($path + "\Cargo.toml") -content $content
}

function getRustSolutionContent {
'pub fn run(args: &Vec<String>) -> Result<String, &''static str> {
    for arg in args {
        println!("{}", arg);
    }
    Err("Not Implemented!")
}
'
}

function getRustMainContent {
    param (
        $projectName
    )
'use aoc_rust_common::{ run_solution, Test };

mod solution;

fn main() {
    let tests: Vec<Test> = vec![
        // Insert test cases here
    ];

    run_solution(&solution::run, tests);    
}
'
}

function makeRustProject {
    param (
        $path,
        $projectName
    )

    makeCargoConfig -projectName $projectName -path $path
    
    $srcPath = $path + "\src"
    makeDirectory -path $srcPath

    $mainContent = getRustMainContent -projectName $projectName
    makeFile -path ($srcPath + "\main.rs") -content $mainContent
    $libContent = getRustSolutionContent
    makeFile -path ($srcPath + "\solution.rs") -content $libContent
}

function makeDayPart {
    param (
        $day,
        $dayPath,
        $part
    )
    $partPath = $dayPath + "\part" + $part
    makeDirectory -path $partPath

    $projectName = "advent_of_code_$year" + "_day$day" + "_part$part"
    makeRustProject -path $partPath -projectName $projectName
}


for($day=1; $day -le 25; $day++) {
    Write-Host Building Day $day
    ##################################################
    # Paths
    ##################################################
    $dayPath = $rootPath + "\day$day"
    makeDirectory -path $dayPath
    for ($i=1; $i -lt 3; $i++) {
        makeDayPart -day $day -dayPath $dayPath -part $i
    }
}

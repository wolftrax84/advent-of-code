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
        # New-Item -Path $path -ItemType File
        if ($content) {
            write-output $content | Out-File -FilePath $path -encoding ASCII
        }
    }
}



$rootPath = '.\'+$year;

makeDirectory -path $rootPath

# ################################################
# # Create task runner
# ################################################
# $vsCodePath = $path + "\.vscode";
# makeDirectory -path $vsCodePath

# $vsCodeTask = $vsCodePath + '\tasks.json'
# $vsCodeTaskContent = '{
#     "version":"2.0.0",
#     "tasks": [{
#         "label": "ts-node",
#         "type": "shell",
#         "command": "ts-node-script",
#         "group": { "kind":"build", "isDefault":true },
#         "args":["${relativeFile}"]
#     }]
# }'
# makeFile -path $vsCodeTask -content $vsCodeTaskContent

################################################
# Create day files
################################################
$dayFileContent = 'const program = ([input]: any[]) => {
    
}

/*******************************************************
 * Test definitions - [expectedValue, input]
 ******************************************************/
const tests: [any, any[]] = [] as any;

/*******************************************************
 * Run code. Shouldn''t need to be modified...
 ******************************************************/
const run = (actualInput: any[]) => {
    let testsPassed = true;
    for(const [test, index] of tests.map((test, index) => [test, index])) {
        const testResult = program(test[1]);
        const passed = test[0] === testResult;
        console.log(`Test ${index} - `, passed ? "Passed" : `Failed: Expected ''${testResult}'' to equal ''${test[0]}''`);
        if (!passed)
            testsPassed = false;
    }
    if (testsPassed)
        console.log(`Actual - ${program(actualInput)}`);
}

import * as fs from "fs"
const partSpecificDataFile = `${__dirname}/${__filename.split("\\").pop().split(".")[0]}.data.txt`;
const dayDataFile = `${__dirname}/data.txt`;
let fileData;
if(fs.existsSync(partSpecificDataFile))
    fileData = fs.readFileSync(partSpecificDataFile, "utf8");
else if(fs.existsSync(dayDataFile))
    fileData = fs.readFileSync(dayDataFile, "utf8");
else
    fileData = "blah"; // Replace with custom data if no data file
run([fileData]);'

function makeCargoConfig {
    param (
        $projectName,
        $path
    )
    $content = '[package]
name = "'+$projectName+'"
version = "0.1.0"
authors = ["Sean Owens <seangabrielowens@gmail.com>"]
edition = "2018"

[dependencies]'

    makeFile -path ($path + "\Cargo.toml") -content $content
}

function getRustLibContent {
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
'use '+$projectName + '::run;
use std::{ fs, process };
use std::io::ErrorKind;

fn main() {
    /////////////////////////////////////////////////////////////
    //    Tests
    /////////////////////////////////////////////////////////////
    let tests: Vec<Test> = vec![
        // Insert test cases here
    ];

    for test in tests {
        if test.run_test() == false {
            process::exit(1);
        }
    }

    /////////////////////////////////////////////////////////////
    //    Actual Puzzle
    /////////////////////////////////////////////////////////////
    let puzzle_input = get_puzzle_input();

    println!("{:?}", run(&vec![puzzle_input]).unwrap_or_else(|error| {
        String::from("Error: ") + error
    }));
}

struct Test {
    expected: String,
    inputs: Vec<String>,
}

impl Test {
    fn run_test(&self) -> bool {
        match run(&self.inputs) {
            Ok(result) => {
                if result == self.expected {
                    true
                } else {
                    println!("Test Failed: expected={} | got={}", self.expected, result);
                    false
                }
            },
            Err(error) => {
                println!("Test Failed: error: {}", error);
                false
            }
        }
    }
}

fn get_puzzle_input() -> String{
    fs::read_to_string("input.txt").unwrap_or_else(|error| {
        if error.kind() == ErrorKind::NotFound {
            fs::read_to_string("../input.txt").unwrap_or_else(|error2| {
                panic!("Problem reading puzzle input from day file: {}", error2);
            })
        } else {
            panic!("Problem reading puzzle input from part file: {}", error);
        }
    })    
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
    $libContent = getRustLibContent
    makeFile -path ($srcPath + "\lib.rs") -content $libContent
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

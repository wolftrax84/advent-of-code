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
# Create task runner
################################################
$vsCodePath = $path + "\.vscode";
makeDirectory -path $vsCodePath

$vsCodeTask = $vsCodePath + '\tasks.json'
$vsCodeTaskContent = '{
    "version":"2.0.0",
    "tasks": [{
        "label": "ts-node",
        "type": "shell",
        "command": "ts-node-script",
        "group": { "kind":"build", "isDefault":true },
        "args":["${relativeFile}"]
    }]
}'
makeFile -path $vsCodeTask -content $vsCodeTaskContent

################################################
# Create git ignore
################################################
$gitIgnoreContent = 'node_modules
package-lock.json';
$gitIgnorePath = $path + '\.gitignore';
makeFile -path $gitIgnorePath -content $gitIgnoreContent


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
const dataFile = `${__dirname}/${__filename.split("\\").pop().split(".")[0]}.data.txt`;
const dayDataFile = `${__dirname}/data.txt`;
let fileData;
if(fs.existsSync(partSpecificDataFile))
    fileData = fs.readFileSync(partSpecificDataFile, "utf8");
else if(fs.existsSync(dayDataFile))
    fileData = fs.readFileSync(dayDataFile, "utf8");
else
    fileData = "Replace with custom data if no data file"
run([fileData]);'

for($i=1; $i -le 25; $i++) {
    $dayPath = $path + "\day$i"
    $dayFileAPath = $dayPath + "\part1.ts"
    $dayFileBPath = $dayPath + "\part2.ts"
    makeDirectory -path $dayPath
    makeFile -path $dayFileAPath -content $dayFileContent
    makeFile -path $dayFileBPath -content $dayFileContent
}

Set-Location $path
npm install @types/node
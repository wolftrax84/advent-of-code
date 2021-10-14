const program = ([input]: any[]) => {
    
}

/*******************************************************
 * Test definitions - [expectedValue, input]
 ******************************************************/
const tests: [any, any[]] = [] as any;

/*******************************************************
 * Run code. Shouldn't need to be modified...
 ******************************************************/
const run = (actualInput: any[]) => {
    let testsPassed = true;
    for(const [test, index] of tests.map((test, index) => [test, index])) {
        const testResult = program(test[1]);
        const passed = test[0] === testResult;
        console.log(`Test ${index} - `, passed ? "Passed" : `Failed: Expected '${testResult}' to equal '${test[0]}'`);
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
run([fileData]);

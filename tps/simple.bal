import ballerina/io;
import ballerina/time;

public function main() {
    int[] arr = [];
    foreach int i in 1...10000 {
        arr.push(i);
    }

    decimal testDuration = 10;
    int queryCount = 0;
    decimal elapsed = 0;
    time:Utc startTime = time:utcNow();
    
    while (elapsed < testDuration) {
        query(arr);
        queryCount += 1;
        time:Utc currentTime = time:utcNow();
        elapsed = time:utcDiffSeconds(currentTime, startTime);
    }

    decimal queriesPerSecond = <decimal>queryCount / testDuration;
    io:println("Total queries executed in ", testDuration, " seconds: ", queryCount);
    io:println("Queries per second: ", queriesPerSecond);
}

function query(int[] arr) {
    int[] arr2 = from int i in arr
        select i * 2;
}
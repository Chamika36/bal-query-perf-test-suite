import ballerina/io;
import ballerina/time;

public function main() {
    int[] arr = [];
    foreach int i in 1...100000 {
        arr.push(i);
    }

    time:Seconds totalTime = 0;
    
    foreach int j in 1...15 {
        time:Utc startTime = time:utcNow();
        query(arr);
        time:Utc endTime = time:utcNow();
        time:Seconds iterationTime = time:utcDiffSeconds(endTime, startTime);
        if (j > 5) {
            io:println("Iteration ", j - 5, ": ", iterationTime, " seconds");
            totalTime += iterationTime;
        }
    }

    decimal averageTime = totalTime / 10;
    io:println("\nAverage execution time: ", averageTime, " seconds");
}

function query(int[] arr) {
    int[] arr2 = from int i in arr
        select i * 2;
}

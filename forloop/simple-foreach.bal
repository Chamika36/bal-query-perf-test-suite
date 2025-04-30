import ballerina/io;
import ballerina/time;

public function main() {
    int[] arr = [];
    foreach int i in 1...1000000 {
        arr.push(i);
    }
    int[] arr2 = [];   

    time:Seconds totalTime = 0;
    
    foreach int j in 1...15 {
        time:Utc startTime = time:utcNow();
        query(arr, arr2);
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

function query(int[] arr, int[] arr2) {
    foreach int i in arr {
        arr2.push(i * 2);
    }
}

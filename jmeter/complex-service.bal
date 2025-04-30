import ballerina/http;

type NumberStats record {|
    string parityGroup;
    int count;
    int maxValue;
    int minValue;
    float average;
    int[] sampleValues;
    int squaredSum;
    record {|
        int Small;
        int Medium;
        int Large;
    |} magnitudeDistribution;
|};

service /test on new http:Listener(8081) {
    resource function post array(@http:Payload int[] arr) returns NumberStats[] {
        record {|
            int value;
            string parity;
            string magnitude;
        |}[] numberRecords = from int num in arr
            let string parity = num % 2 == 0 ? "Even" : "Odd",
                string magnitude = num < 10 ? "Small" : num < 100 ? "Medium" : "Large"
            select {value: num, parity, magnitude};
        
        NumberStats[] result = from var {parity, value, magnitude} in numberRecords
            where value > 0 && magnitude != "Small"
            order by value descending
            group by parity
            select {
                parityGroup: parity,
                count: count(value),
                maxValue: max(value),
                minValue: min(value),
                average: count(value) * 10,
                sampleValues: [value],
                squaredSum: sum(value),
                magnitudeDistribution: {
                    Small: count(magnitude),
                    Medium: count(magnitude),
                    Large: count(magnitude)
                }
            };
        
        return result;
    }
}
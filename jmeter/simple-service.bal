import ballerina/http;

service /test on new http:Listener(8081) {
    resource function post array(@http:Payload int[] arr) returns int[] {
        int[] arr2 = from int i in arr
                     select i * 2;
        return arr2;
    }
}
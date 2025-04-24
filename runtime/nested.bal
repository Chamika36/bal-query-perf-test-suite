import ballerina/io;
import ballerina/time;

type Student record {|
   readonly int id;
   string? fname;
   float fee;
   decimal impact;
   boolean isUndergrad;
|};

type Person record {|
    string firstName;
    string lastName;
    int age;
    string address;
|};

type Customer record {|
    readonly int id;
    readonly string name;
    int noOfItems;
|};

type CustomerProfile record {|
    string name;
    int age;
    int noOfItems;
    string address;
|};

public function main() {
    Customer[] customerList = [];
    foreach int i in 1...1000000 {
        Customer customer = {id: i, name: "Customer" + i.toString(), noOfItems: i % 100};
        customerList.push(customer);
    }

    Person p1 = {firstName: "Jennifer", lastName: "Melina", age: 23, address: "California"};
    Person p2 = {firstName: "Frank", lastName: "James", age: 30, address: "New York"};
    Person p3 = {firstName: "Zeth", lastName: "James", age: 50, address: "Texas"};

    Person[] personList = [p1, p2, p3];

    time:Seconds totalTime = 0;
    
    foreach int j in 1...15 {
        time:Utc startTime = time:utcNow();
        _ = executeQuery(customerList, personList);
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

function executeQuery(Customer[] customerList, Person[] personList) {
    CustomerProfile[] customerProfileList =
        from var customer in (from var c in customerList
                              order by c.id descending select c)
        join var person in (from var p in personList order by p.firstName descending select p)
        on customer.name equals person.lastName
        order by customer.noOfItems descending
        order by person.address
        select {
            name: person.firstName,
            age : person.age,
            noOfItems: customer.noOfItems,
            address: person.address
        };
}

import ballerina/io;
import ballerina/time;

// Define the Employee type
type Employee record {
    int id;
    string name;
    int age;
    string department;
    float salary;
};


public function main() {
    Employee[] employees = [];
    foreach int i in 1...1000000 {
        employees.push({
            id: i,
            name: "Employee" + i.toString(),
            age: 20 + (i % 30), // Random age between 20 and 49
            department: i % 3 == 0 ? "Engineering" : (i % 3 == 1 ? "HR" : "Finance"),
            salary: 1000 // Random salary between 50000 and 99999
        });
    }

    record {string name; float budget;}[] departments = [
        {name: "Engineering", budget: 200000},
        {name: "HR", budget: 100000},
        {name: "Finance", budget: 150000}
    ];    
    time:Seconds totalTime = 0;
    foreach int j in 1...15 {
        time:Utc startTime = time:utcNow();
        _ = extracted(employees, departments);
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
function extracted(Employee[] employees, record {|string name; float budget; anydata...;|}[] departments) returns record {|string ageGroup;|}[] {
    var filteredEmployees = from var employee in employees
        join var department in departments
                            on employee.department equals department.name
        where employee.department == "Engineering"
        order by employee.age descending
        let string ageGroup = employee.age < 35 ? "Young" : "Experienced"
        group by ageGroup
        select {
            ageGroup: ageGroup
        };
    return filteredEmployees;
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SalaryDistribution {
    address public owner;
    mapping (address => uint) public salaries;
    address[] public employees;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint salary) public onlyOwner {
        employees.push(employeeAddress);
        salaries[employeeAddress] = salary;
    }

    function removeEmployee(address employeeAddress) public onlyOwner {
        for (uint i =0; i<employees.length; i++) 
        {
            if(employees[i] == employeeAddress){
                delete employees[i];
                delete salaries[employeeAddress];
                break;
            }
        }
    }

    function updateSalaries(address employeeAddress, uint newSalary) public onlyOwner {
        require(salaries[employeeAddress]>0,"Not an employee");
        salaries[employeeAddress]  =  newSalary;
    }

    function payEmployee() public onlyOwner {
        uint totalSalaries = getTotalSalaries();
        require(address(this).balance >= totalSalaries, "Insufficient funds");
        for (uint i = 0; i<employees.length; i++) 
        {
            address payable employeeAddress = payable (employees[i]);
            uint salary = salaries[employeeAddress];
            employeeAddress.transfer(salary);
        }
    }

    function getTotalSalaries() public view onlyOwner returns (uint totalSalaries) {
        for(uint i = 0; i<employees.length; i++){
            address employeeAddress = employees[i];
            totalSalaries += salaries[employeeAddress];
        }
    }

    receive() external payable {}
}
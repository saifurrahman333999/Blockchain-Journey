// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 3: Student Record
// A small list of students, using a struct and an array.

contract StudentRecord {
    struct Student {
        string name;
        uint roll;
        uint cgpaTimes100;
        // CGPA stored as an integer, multiplied by 100.
        // e.g. a CGPA of 3.75 is stored as 375,
        // because Solidity has no decimal/float type.
    }

    // All students are kept in this array.
    Student[] public students;

    // Function to add a new student.
    function addStudent(string memory _name, uint _roll, uint _cgpaTimes100) public {
        students.push(Student(_name, _roll, _cgpaTimes100));
    }

    // Function to get one student's info by their index in the array.
    function getStudent(uint _index) public view returns (string memory, uint, uint) {
        Student memory s = students[_index];
        return (s.name, s.roll, s.cgpaTimes100);
    }

    // Function to check the total number of students.
    function totalStudents() public view returns (uint) {
        return students.length;
    }

}
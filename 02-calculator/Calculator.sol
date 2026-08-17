// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 2: Calculator
// Four basic math operations - add, subtract, multiply, divide.

contract Calculator {
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function subtract(uint a, uint b) public pure returns (uint) {
        return a - b;
    }

    function multiply(uint a, uint b) public pure returns (uint) {
        return a * b;
    }

    function divide(uint a, uint b) public pure returns (uint) {
        // If b is 0, division is not allowed, so we block it with require.
        require(b != 0, "Cannot divide by zero");
        return a / b;
    }
}
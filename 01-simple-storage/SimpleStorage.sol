// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 1: Simple Storage
// Stores a single number on the blockchain, and lets us read it back later.

contract SimpleStorage {
    // This variable is permanently stored on the blockchain.
    uint num;

    // Function to store a new number.
    function store(uint _newNum) public {
        num = _newNum;
    }

    // Function to read (retrieve) the stored number.
    // "view" means this function doesn't change anything, it only reads —
    // so calling it costs no gas. 
    function retrieve() public view returns (uint) {
        return num;
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing OpenZeppelin's audited, standard ERC-20 implementation.
// This provides transfer, balanceOf, approve, allowance, transferFrom,
// totalSupply, and the Transfer/Approval events — all EIP-20 compliant,
// without writing that logic from scratch.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title LearnToken
/// @notice A simple ERC-20 token built by extending OpenZeppelin's ERC20 contract.
/// @dev Practices inheritance and the use of an audited library instead of
///      writing token logic from scratch.
contract LearnToken is ERC20 {
    /// @param initialSupply The number of tokens to mint to the deployer,
    ///        expressed in the smallest unit (already multiplied by 10^decimals).
    constructor(uint256 initialSupply) ERC20("LearnToken", "LRN") {
        // _mint is an internal function inherited from ERC20.
        // It creates new tokens and assigns them to msg.sender (the deployer),
        // and automatically emits a Transfer event from the zero address.
        _mint(msg.sender, initialSupply);
    }
}

# Voting System (Solidity)

A simple on-chain voting smart contract that lets an owner register candidates, allows any address to cast one vote, and computes the current winner at any time — all without an off-chain tally.

## Features

- **Candidate registration** — restricted to the contract owner
- **One vote per address** — enforced on-chain, no double voting
- **Live winner lookup** — anyone can query the current leading candidate at any point, even before voting ends
- **Voting lifecycle control** — the owner can close voting, after which no further votes are accepted
- **Full event logging** — every state-changing action (registration, vote, end of voting) emits an event for transparency

## Concepts Practiced

| Concept | Where it's used |
|---|---|
| `mapping` | Tracking candidates and voter status |
| `struct` | Storing candidate data (name, vote count, existence flag) |
| `modifier` | `onlyOwner` and `votingIsOpen` for access control |
| `require` / `revert` | Rejecting invalid input and unauthorized actions |
| `event` | `CandidateRegistered`, `VoteCast`, `VotingEnded` |

## Contract Overview

```solidity
function registerCandidate(string memory _name) external onlyOwner
function vote(string memory _candidateName) external votingIsOpen
function endVoting() external onlyOwner votingIsOpen
function getVotes(string memory _candidateName) external view returns (uint256)
function getAllCandidates() external view returns (string[] memory)
function getWinner() external view returns (string memory, uint256)
```

## How to Run

### Option 1: Remix IDE (no installation required)

1. Open [remix.ethereum.org](https://remix.ethereum.org)
2. Create a new file named `VotingSystem.sol` and paste the contract code
3. Go to the **Solidity Compiler** tab and compile with version `0.8.20` or higher
4. Go to **Deploy & Run Transactions**, select the **Remix VM** environment, and deploy
5. Test the flow:
   - As the owner account, call `registerCandidate("Alice")` and `registerCandidate("Bob")`
   - Switch to a different account and call `vote("Alice")`
   - Call `getWinner()` to see the current leader
   - Call `endVoting()` to close voting

### Option 2: Foundry

```bash
forge init voting-system
# place VotingSystem.sol inside the src/ folder
forge build
```

## Design Notes

- Candidates are identified by `string` name for simplicity. In a production setting, using a `bytes32` identifier or a numeric ID would be more gas-efficient.
- There is currently no automated test suite — this is planned as part of a later milestone where the project moves to Foundry for testing.
- Vote weight is uniform (1 address = 1 vote). Weighted or token-gated voting is out of scope for this version.


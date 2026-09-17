// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Voting System
// A simple contract to register candidates, let voters cast votes,
// and announce the winner once voting ends.

contract VotingSystem {
    // State variables
    address public owner;
    bool public votingOpen;

    struct Candidate {
        string name;
        uint256 voteCount;
        bool exists;
    }

    // candidate name => Candidate details
    mapping(string => Candidate) private candidates;
    string[] private candidateNames; // keep track of all registered names

    // voter address => has voted or not
    mapping(address => bool) public hasVoted;

  
    // Events
    event CandidateRegistered(string name);
    event VoteCast(address indexed voter, string candidate);
    event VotingEnded(string winnerName, uint256 winningVoteCount);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier votingIsOpen() {
        require(votingOpen, "Voting is not open");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
        votingOpen = true; // voting starts open; owner can close it when done
    }

    // Owner functions
    // Register a new candidate. Only the owner can do this.
    function registerCandidate(string memory _name) external onlyOwner {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(!candidates[_name].exists, "Candidate already registered");

        candidates[_name] = Candidate({name: _name, voteCount: 0, exists: true});
        candidateNames.push(_name);

        emit CandidateRegistered(_name);
    }

    // Close voting so no more votes can be cast.
    function endVoting() external onlyOwner votingIsOpen {
        votingOpen = false;

        (string memory winnerName, uint256 winnerVotes) = _getWinner();
        emit VotingEnded(winnerName, winnerVotes);
    }

    // Voter functions
    // Cast a vote for a registered candidate.
    function vote(string memory _candidateName) external votingIsOpen {
        require(candidates[_candidateName].exists, "Candidate does not exist");
        require(!hasVoted[msg.sender], "You have already voted");

        hasVoted[msg.sender] = true;
        candidates[_candidateName].voteCount += 1;

        emit VoteCast(msg.sender, _candidateName);
    }

    // View functions
    // Get vote count for a specific candidate.
    function getVotes(string memory _candidateName) external view returns (uint256) {
        require(candidates[_candidateName].exists, "Candidate does not exist");
        return candidates[_candidateName].voteCount;
    }

    // Get the list of all registered candidate names.
    function getAllCandidates() external view returns (string[] memory) {
        return candidateNames;
    }

    // Get the current winner (can be called anytime, even mid-voting).
    function getWinner() external view returns (string memory winnerName, uint256 winnerVotes) {
        return _getWinner();
    }

    // Internal helpers
    function _getWinner() internal view returns (string memory winnerName, uint256 winnerVotes) {
        require(candidateNames.length > 0, "No candidates registered");

        uint256 highestVotes = 0;
        string memory leadingCandidate = "";

        for (uint256 i = 0; i < candidateNames.length; i++) {
            string memory currentName = candidateNames[i];
            uint256 currentVotes = candidates[currentName].voteCount;

            if (currentVotes > highestVotes) {
                highestVotes = currentVotes;
                leadingCandidate = currentName;
            }
        }

        return (leadingCandidate, highestVotes);
    }
}

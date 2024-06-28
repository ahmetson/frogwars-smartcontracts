// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// todo session to reset when leaders announced
contract Leaderboard is Ownable {
    address public lobby;
    mapping(address => uint256) public _scores;
    address[] private _players;

    uint public unlockTime;
    uint256 leaderboardLength = 10;

    mapping(uint256 => address) public leaderboard;

    event ScoreAdded(address indexed player, uint256 score);

    modifier onlyLobby {
        require(lobby == msg.sender, "not lobby");
        _;
    }

    constructor() Ownable(msg.sender) {}

    function setLobby(address lobby_) external onlyOwner {
        lobby = lobby_;
    }

    function submitScore(uint256 score, address winner) external onlyLobby {
        _scores[winner] += score;
        emit ScoreAdded(winner, _scores[winner]);
        
        // if the score is too low, don't update
        address lastOnBoard = leaderboard[leaderboardLength - 1];
        uint256 lastScore = _scores[lastOnBoard];
        if (lastScore >= score) return;

        // loop through the leaderboard
        for (uint256 i = 0; i < leaderboardLength; i++) {
            address playerOnBoard = leaderboard[i];
            uint256 playerScore = _scores[playerOnBoard];

            // find where to insert the new score
            if (playerScore < _scores[winner]) {
                // shift leaderboard
                address currentUser = leaderboard[i];
                for (uint256 j = i + 1; j < leaderboardLength + 1; j++) {
                    address nextUser = leaderboard[j];
                    leaderboard[j] = currentUser;
                    currentUser = nextUser;
                }
                // insert
                leaderboard[i] = winner;
                // delete last from list
                delete leaderboard[leaderboardLength];
            }
        }
    }
}

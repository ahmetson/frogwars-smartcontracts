// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Leaderboard} from "./Leaderboard.sol";

contract Lobby is AccessControl  {
    bytes32 public constant SERVER_ROLE = keccak256("SERVER");
    IERC20 public token;
    uint256 public depositAmount;    // deposit amount
    uint256 public winnerAmount;
    uint256 public burnAmount;
    uint256 public feeAmount;
    address public feeReceiver;
    Leaderboard public leaderboard;

    struct Match {
        address player1;
        address player2;
    }

    address[] public deposits;
    // player => depositId
    mapping(address => uint256) public playerDeposits;
    mapping(address => uint256) public playerMatches;
    mapping(uint256 => Match) public matches;

    uint256 public matchIds;

    event Deposit(address indexed player);
    event Withdraw(address indexed player);
    event Start(address indexed player1, address indexed player2, uint256 indexed matchId);
    event End(address indexed winner, address indexed loser, uint256 indexed matchId);

    constructor(address feeReceiver_) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        feeReceiver = feeReceiver_;
    }

    function setGameParams(address token_,
        uint256 deposit_,    // deposit amount
        uint256 winner_,
        uint256 burn_,
        uint256 fee_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(token_ != address(0) && deposit_ > 0 && winner_ > 0 && burn_ > 0 && fee_ > 0, "0");
        token = IERC20(token_);
        depositAmount = deposit_;
        winnerAmount = winner_;
        burnAmount = burn_;
        feeAmount = fee_;
    }

    function setFeeReceiver(address feeReceiver_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        feeReceiver = feeReceiver_;
    }

    function setLeaderboard(address leaderboard_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        leaderboard = Leaderboard(leaderboard_);
    }

    function grantServerRole(address server_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(SERVER_ROLE, server_);
    }

    function revokeServerRole(address server_) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(hasServerRole(server_), "not a server");
        _revokeRole(SERVER_ROLE, server_);
    }

    function hasServerRole(address server_) public view returns(bool) {
        return hasRole(SERVER_ROLE, server_);
    }

    function deposit() external {
        require(!isPlayerRegistered(msg.sender), "already deposited");
        require(!isPlayerPlaying(msg.sender), "already playing");
        
        require(token.transferFrom(msg.sender, address(this), depositAmount), "failed to obtain tokens");

        deposits.push(msg.sender);
        playerDeposits[msg.sender] = deposits.length - 1;

        matchPlayers();

        emit Deposit(msg.sender);
    }

    function withdraw() external {
        require(isPlayerRegistered(msg.sender), "no deposit");
        require(!isPlayerPlaying(msg.sender), "already playing");
        uint256 index = playerDeposits[msg.sender];

        require(token.transfer(msg.sender, depositAmount), "failed to transfer tokens");

        // clean the data
        if (deposits.length - 1 == index) {
            deposits.pop();
        } else {
            deposits[index] = deposits[deposits.length - 1];
            deposits.pop();
        }

        delete playerDeposits[msg.sender];

        emit Withdraw(msg.sender);
    }

    function isPlayerRegistered(address player) private view returns(bool) {
        uint256 index = playerDeposits[player];
        return deposits[index] != address(0);
    }

    function isPlayerPlaying(address player) private view returns(bool) {
        return playerMatches[player] > 0;
    }

    function matchPlayers() internal {
        if (deposits.length != 2) {
            return;
        }

        matchIds++;
        address player1 = deposits[0];
        address player2 = deposits[1];
        matches[matchIds].player1 = player1;
        matches[matchIds].player2 = player2;

        playerMatches[player1] = matchIds;
        playerMatches[player2] = matchIds;

        delete playerDeposits[player1];
        delete playerDeposits[player2];
        deposits.pop();
        deposits.pop();

        emit Start(player1, player2, matchIds);
    }

    function finishMatchByPlayer(address player_, address winner_) external onlyRole(SERVER_ROLE) {
        require(isPlayerPlaying(player_), "not a player");
        finishMatch(playerMatches[player_], winner_);
    }

    function finishMatch(uint256 matchId, address winner_) public onlyRole(SERVER_ROLE) {
        Match storage matching = matches[matchId];
        require(matching.player1 == winner_ || matching.player2 == winner_, "invalid winner");

        address loser = matching.player1;
        if (winner_ == loser) {
            loser = matching.player2;
        }

        delete playerMatches[matching.player1];
        delete playerMatches[matching.player2];
        delete matches[matchId];

        token.transfer(address(0), burnAmount);
        token.transfer(winner_, winnerAmount);
        token.transfer(feeReceiver, feeAmount);

        // Update the leaderboard
        leaderboard.submitScore(winnerAmount, winner_);

        emit End(winner_, loser, matchId);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/AccessControl.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

contract GameMaster is AccessControl {
    using SafeMath for uint256;

    bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
    bytes32 public constant UPGRADER_ROLE = keccak256('UPGRADER_ROLE');

    Counters.Counter public gameId;
    address public token;
    address public nft;
    address public gameMaster;
    uint256 public hostingFeeX10;
    mapping(address => uint256) public playerToGameId;

    constructor(address erc20, address erc721) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(UPGRADER_ROLE, msg.sender);

        token = erc20;
        nft = erc721;

        gameMaster = msg.sender;
        hostingFeeX10 = 50; // 5%
    }

    /**
     * Game Master
     */
    function setGameMaster(address newGameMaster)
        external
        onlyRole(MINTER_ROLE)
    {
        gameMaster = newGameMaster;
    }

    /**
     *  Players and game
     */
    struct Player {
        uint256 ticket;
        uint256 point;
    }

    struct GameInfo {
        uint256 id;
        address[] players;
        bool isActive;
        mapping(address => bool) addressToRewarded;
    }

    mapping(address => Player) public players;
    mapping(uint256 => GameInfo) public games;

    event GameStarted(uint256 gameid, address[] players, bool isActive);
}

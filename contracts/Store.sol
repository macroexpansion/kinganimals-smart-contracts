// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import './interfaces/INFT.sol';

contract Store is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public token;
    IERC721 public nft;

    uint256 public price;
    address public dev;
    bool public isPaused;

    constructor(address erc20, address erc721) {
        token = IERC20(erc20);
        nft = IERC721(erc721);

        price = uint256(1000).mul(1e6);
        dev = msg.sender;

        isPaused = false;
    }

    function setPause(bool _pause) external onlyOwner {
        isPaused = _pause;
    }

    function setDev(address newDev) external onlyOwner {
        dev = newDev;
    }

    function setPrice(uint256 newPrice) external onlyOwner {
        price = newPrice;
    }

    event Bought(address buyer, uint256 itemId, string uri, uint256 timestamp);

    function buy(uint256 num) external {
        require(!isPaused, 'Store: contract is being paused currently');
        require(
            num > 0 && num <= 10,
            'buy: number of NFT to buy must be greater than 0 and smaller than or equal 10'
        );

        token.safeTransferFrom(msg.sender, dev, price.mul(num));

        string memory uri = '';
        for (uint256 i = 0; i < num; i++) {
            INFT(address(nft)).mint(msg.sender, uri, 10);

            emit Bought(msg.sender, 10, uri, block.timestamp);
        }
    }
}

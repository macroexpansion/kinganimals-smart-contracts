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

    address public dev;
    bool public isPaused;
    mapping (uint256 => uint256) public quantity;
    mapping (uint256 => uint256) public prices;

    constructor(address erc20, address erc721) {
        token = IERC20(erc20);
        nft = IERC721(erc721);

        dev = msg.sender;

        isPaused = false;
    }

    function setToken(address _token) external onlyOwner {
        token = IERC20(_token);
    }

    function setNFT(address _nft) external onlyOwner {
        nft = IERC721(_nft);
    }

    function setPause(bool _pause) external onlyOwner {
        isPaused = _pause;
    }

    function setDev(address newDev) external onlyOwner {
        dev = newDev;
    }

    function setPrice(uint256[] memory itemIds, uint256[] memory newPrices) external onlyOwner {
        require(itemIds.length == newPrices.length, "setPrice: arrays length are not equal");

        for (uint256 i = 0; i < itemIds.length; i++) {
            prices[itemIds[i]] = newPrices[i];
        }
    }

    function setQuantity(uint256[] memory _itemIds, uint256[] memory _newQuantities) external onlyOwner {
        require(_itemIds.length == _newQuantities.length, "setQuantity: both array length must be equal");
        for (uint256 i = 0; i < _itemIds.length; i++) {
            quantity[_itemIds[i]] = _newQuantities[i];
        }
    }

    event Bought(address buyer, uint256 itemId, string uri, uint256 timestamp);

    function buy(uint256 num, string memory uri, uint256 itemId) external {
        require(!isPaused, 'Store: contract is being paused currently');
        require(
            num > 0 && num <= 10,
            'buy: number of NFT to buy must be greater than 0 and smaller than or equal 10'
        );
        require(num <= quantity[itemId], "buy: not enough quantity to buy");

        token.safeTransferFrom(msg.sender, dev, prices[itemId].mul(num));
        quantity[itemId] = quantity[itemId] - num;

        for (uint256 i = 0; i < num; i++) {
            INFT(address(nft)).mint(msg.sender, uri, itemId);

            emit Bought(msg.sender, itemId, uri, block.timestamp);
        }
    }
}

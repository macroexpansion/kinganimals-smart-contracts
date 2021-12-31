// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

import './interfaces/INFT.sol';

contract UserInfo {
    IERC20 public token;
    IERC721 public nft;

    constructor(address erc20, address erc721) {
        token = IERC20(erc20);
        nft = IERC721(erc721);
    }

    function getUserNft(address _address)
        external
        view
        returns (uint256[] memory, uint256[] memory, string[] memory)
    {
        uint256 balance = nft.balanceOf(_address);

        uint256[] memory tokenIds = new uint256[](balance);
        uint256[] memory itemIds = new uint256[](balance);
        string[] memory uris = new string[](balance);

        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = ERC721Enumerable(address(nft)).tokenOfOwnerByIndex(_address, i);
            uint256 itemId = INFT(address(nft)).getNftInfo(tokenId);
            string memory uri = ERC721URIStorage(address(nft)).tokenURI(tokenId);

            tokenIds[i] = tokenId;
            itemIds[i] = itemId;
            uris[i] = uri;
        }

        return (tokenIds, itemIds, uris);
    }
}

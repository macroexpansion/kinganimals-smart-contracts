// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

import './interfaces/INFT.sol';

contract UserInfo {
    IERC20 public token;
    IERC721 public kan;
    IERC721 public kai;

    constructor(address _token, address _kan, address _kai) {
        token = IERC20(_token);
        kan = IERC721(_kan);
        kai = IERC721(_kai);
    }

    function getUserNft(address _address)
        external
        view
        returns (uint256[] memory, uint256[] memory, string[] memory)
    {
        uint256 balance = kan.balanceOf(_address);

        uint256[] memory tokenIds = new uint256[](balance);
        uint256[] memory itemIds = new uint256[](balance);
        string[] memory uris = new string[](balance);

        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = ERC721Enumerable(address(kan)).tokenOfOwnerByIndex(_address, i);
            uint256 itemId = INFT(address(kan)).getNftInfo(tokenId);
            string memory uri = ERC721URIStorage(address(kan)).tokenURI(tokenId);

            tokenIds[i] = tokenId;
            itemIds[i] = itemId;
            uris[i] = uri;
        }

        return (tokenIds, itemIds, uris);
    }

    function getUserItem(address _address)
        external
        view
        returns (uint256[] memory, uint256[] memory, string[] memory)
    {
        uint256 balance = kai.balanceOf(_address);

        uint256[] memory tokenIds = new uint256[](balance);
        uint256[] memory itemIds = new uint256[](balance);
        string[] memory uris = new string[](balance);

        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = ERC721Enumerable(address(kai)).tokenOfOwnerByIndex(_address, i);
            uint256 itemId = INFT(address(kai)).getNftInfo(tokenId);
            string memory uri = ERC721URIStorage(address(kai)).tokenURI(tokenId);

            tokenIds[i] = tokenId;
            itemIds[i] = itemId;
            uris[i] = uri;
        }

        return (tokenIds, itemIds, uris);
    }
}

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

    /**
     *  Token info
     */
    struct TokenInfo {
        uint256 tokenId;
        uint256 itemId;
        address contractAddress;
        string uri;
    }

    function getUserNFT(address _address)
        external
        view
        returns (TokenInfo[] memory)
    {
        uint256 balance = nft.balanceOf(_address);

        TokenInfo[] memory tokens = new TokenInfo[](balance);
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = ERC721Enumerable(address(nft))
                .tokenOfOwnerByIndex(_address, i);
            uint256 itemId = INFT(address(nft)).getNftInfo(tokenId);
            string memory uri = ERC721URIStorage(address(nft)).tokenURI(
                tokenId
            );

            tokens[i] = TokenInfo(tokenId, itemId, address(nft), uri);
        }

        return tokens;
    }
}

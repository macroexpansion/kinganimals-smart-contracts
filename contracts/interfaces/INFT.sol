// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INFT {
    function getNftInfo(uint256 tokenId) external view returns (uint256);
    function mint(address user, string memory uri, uint256 itemId) external;
}

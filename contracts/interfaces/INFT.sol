// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INFT {
    function getNftInfo(uint256 tokenId) external view returns (uint256);
}

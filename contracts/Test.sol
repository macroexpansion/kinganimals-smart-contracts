// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';

contract Test is Ownable {
    uint256 public num = 5;

    constructor(uint256 _num) {
        num = _num;
    }

    event NumChanged(uint256 oldValue, uint256 newValue);

    function setNum(uint256 _num) external onlyOwner {
        uint256 old = num;
        num = _num;
        
        emit NumChanged(old, num);
    }
}

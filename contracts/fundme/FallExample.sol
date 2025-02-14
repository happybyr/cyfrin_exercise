// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract FallbackExample {
    uint256 public result;

    // low level calldata without param(can receive eth)
    receive() external payable {
        result = 1;
    }

    // low level calldata with param(can receive eth)
    fallback() external payable {
        result = 2;
    }
}
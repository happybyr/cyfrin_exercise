// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // without constant 860511
    // with constant constant
    uint public constant MINIMUN_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent 5$
        // 1.How do we send ETH to this contract?
        require(msg.value.getConversionRate() >= MINIMUN_USD, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        // What is revert?
        // Undo any actions that have been done, and send the remaining gas back
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        // actually withdraw the funds

        // transfer throw error, reveret
        // payable(msg.sender).transfer(address(this).balance);
        // send return boolean
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Must be owner!");

        // custom errors is more gas efficiency
        // if (msg.sender != i_owner) {
        //     revert NotOwner();
        // }
        _;  // stand for function logic (before require or after)
    }

    // in case somebody send this contract money instead of calling the fund function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
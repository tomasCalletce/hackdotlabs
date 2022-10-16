// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;



contract RetirementSavings {

    uint startBalance;
    uint  expiration;


    constructor() payable {
        require(msg.value == .1 ether);
        expiration = block.timestamp + 100 days;
        startBalance = .1 ether;
    }

   
    function withdraw() public {
        require(address(this).balance == .1 ether);

        if (block.timestamp < expiration) {
            payable(msg.sender).transfer(address(this).balance * 9 / 10);
        } else {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function collectPenalty() public {
        uint256 withdrawn = startBalance - address(this).balance;

        require(withdrawn > 0);

        payable(msg.sender).transfer(address(this).balance);
    }
}
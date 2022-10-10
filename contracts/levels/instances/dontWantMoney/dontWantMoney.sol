// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract DontWantMoney {

    function somethingToSay() external pure  returns(string memory _hello) {
        _hello = "hackLabs";
    }

    function getBalance() external view returns(uint){
        return address(this).balance;
    }

}
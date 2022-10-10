// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


error  tooEarly(uint timeLeft);


contract Facet {

    uint helper;
    uint waitTime;
    bool unlocked;

    function setHelper(uint _helper) external {
        helper = _helper;
    }


    function unlock() external {
        if(block.timestamp < block.timestamp + waitTime){
            revert tooEarly(waitTime);
        }
        unlocked = true;
    }


}
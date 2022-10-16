// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


error  tooEarly(uint timeLeft);


contract Facet {

    uint public timePassed;
    address public facet;
    uint public startOfCount;
    bool public unlocked;
    uint public constant waitTime = 100;

    function updateTime() external {
        timePassed = block.timestamp - startOfCount;
    }

    function unlock() external {
        if(timePassed >= 100 days){
            revert tooEarly(waitTime);
        }
        unlocked = true;
    }


}
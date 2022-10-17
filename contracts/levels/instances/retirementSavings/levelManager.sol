// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import { RetirementSavings } from "./retirementSavings.sol";


contract retirementSavingsLevelManager  {

    uint public points;
    uint public timeBonus;

    constructor(uint _points,uint _timeBonus){
        points = _points;
        timeBonus = _timeBonus;
    }

    function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus){
        RetirementSavings _ins = new RetirementSavings{value: msg.value}();
        return (address(_ins),points,timeBonus);
    }
    function validateInstance(address _instance) virtual public returns (bool){
       if(_instance.balance == 0){
            return true;
       }
       return false;
    }
  
}




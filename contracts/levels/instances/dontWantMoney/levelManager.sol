// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import { DontWantMoney } from "./DontWantMoney.sol";


contract IdontWantMoneyManager  {

    uint public points;
    uint public timeBonus;

    constructor(uint _points,uint _timeBonus){
        points = _points;
        timeBonus = _timeBonus;
    }

    function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus){
        DontWantMoney _ins = new DontWantMoney();
        return (address(_ins),points,timeBonus);
    }
    function validateInstance(address payable _instance, address _player) virtual public returns (bool){
       if(_instance.balance > 0){
            return true;
       }
       return false;
    }
  
}

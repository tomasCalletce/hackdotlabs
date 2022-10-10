// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Guess } from "./guess.sol";


contract GuessLevel  {

    uint public points;
    uint public timeBonus;

    constructor(uint _points,uint _timeBonus){
        points = _points;
        timeBonus = _timeBonus;
    }

    function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus){
        Guess _ins = new Guess();
        return (address(_ins),points,timeBonus);
    }

    function validateInstance(address payable _instance, address _player) virtual public returns (bool){
        Guess _ins = Guess(_instance);
       return _ins.foundTheSecret();
    }
  
}
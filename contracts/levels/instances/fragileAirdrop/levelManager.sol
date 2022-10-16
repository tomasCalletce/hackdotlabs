// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import { QuestionableAirdrop } from "./fragileAirdropLevel.sol";


contract FragileAirdropLevelManager  {

    uint public points;
    uint public timeBonus;

    constructor(uint _points,uint _timeBonus){
        points = _points;
        timeBonus = _timeBonus;
    }

    function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus){
        QuestionableAirdrop _ins = new QuestionableAirdrop();
        return (address(_ins),points,timeBonus);
    }
    function validateInstance(address payable _instance) virtual public returns (bool){
        QuestionableAirdrop _ins = QuestionableAirdrop(_instance);
        if(_ins.getUserBalance(tx.origin) > _ins.airdropAmount()){
            return true;
        }
        return false;
    }
  
}


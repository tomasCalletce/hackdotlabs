// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import { StoreMyPrivateData } from "./storeMyPrivateData.sol";


contract retirementSavingsLevelManager  {

    uint public points;
    uint public timeBonus;

    constructor(uint _points,uint _timeBonus){
        points = _points;
        timeBonus = _timeBonus;
    }

    function createInstance() virtual public payable returns (address _instance,uint _points,uint _timeBonus){
        StoreMyPrivateData _ins = new StoreMyPrivateData();
        return (address(_ins),points,timeBonus);
    }
    function validateInstance(address _instance) virtual public returns (bool){
        StoreMyPrivateData _ins = StoreMyPrivateData(_instance);
        return _ins.foundTheSecret();
    }
  
}

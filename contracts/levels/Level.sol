// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import '@openzeppelin/contracts/access/Ownable.sol';

abstract contract Level is Ownable {
  function createInstanceANDgetPoints(address _player) virtual public payable returns (address,uint);
  function validateInstance(address payable _instance, address _player) virtual public returns (bool);
}
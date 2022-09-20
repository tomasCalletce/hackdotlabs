// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import './levels/Level.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Ethernaut is Ownable {

  event LevelInstanceCreatedLog(address indexed player, address instance);
  event LevelCompletedLog(address indexed player, Level level);

  mapping(address => bool) registeredLevels;
  mapping(address => EmittedInstanceData) emittedInstances;
  mapping(address => uint) totalPointsPerPlayer;

  struct EmittedInstanceData {
    address player;
    Level level;
    bool completed;
    uint points;
  }

  function registerLevel(Level _level) public onlyOwner {
    registeredLevels[address(_level)] = true;
  }

  function createLevelInstance(Level _level) public payable {
    require(registeredLevels[address(_level)]);
    (address instance,uint instancePoints) = _level.createInstanceANDgetPoints{value:msg.value}(msg.sender);
    emittedInstances[instance] = EmittedInstanceData(msg.sender, _level, false,instancePoints);

    emit LevelInstanceCreatedLog(msg.sender, instance);
  }

  function submitLevelInstance(address payable _instance) public {
    EmittedInstanceData storage data = emittedInstances[_instance];
    require(data.player == msg.sender); 
    require(data.completed == false); 

    if(data.level.validateInstance(_instance, msg.sender)) {
      data.completed = true;
      totalPointsPerPlayer[data.player] += data.points;
      emit LevelCompletedLog(msg.sender, data.level);
    }
  }

}
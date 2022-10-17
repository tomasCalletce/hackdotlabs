// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Level } from './levels/Level.sol';
import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { Pausable} from '@openzeppelin/contracts/security/Pausable.sol';

/******************************************************************************\
* HackLans ctf Medellin 
*
* good luck, and happy hacking.
/******************************************************************************/

struct EmittedInstanceData {
    address player;
    address level;
    bool completed;
    uint points;
    uint timeBonus;
}

error levelNotRegistered(address _attempt);
error alreadyCompleted();
error notplayer(address _attempt);


contract HackLab is Ownable, Pausable {

  event LevelInstanceCreatedLog(address indexed player, address instance);
  event LevelCompletedLog(address indexed player,address level);

  mapping(address => bool) public registeredLevels;
  mapping(address => EmittedInstanceData) public emittedInstances;
  mapping(address => uint) public totalPointsPerPlayer;

  address public winner;

  function createLevelInstance(address _levelAddress) external payable {
    Level _level = Level(_levelAddress);
    if(!registeredLevels[_levelAddress]){
        revert levelNotRegistered(_levelAddress);
    }
    (address _instance,uint _points,uint _timeBonus) = _level.createInstance{value: msg.value}();
    emittedInstances[_instance] = EmittedInstanceData(msg.sender,_levelAddress,false,_points,_timeBonus);

    emit LevelInstanceCreatedLog(msg.sender, _instance);
  }

  function submitLevelInstance(address _instance) external whenNotPaused {
    EmittedInstanceData storage _data = emittedInstances[_instance];
    if(_data.player != msg.sender){
      revert notplayer(msg.sender);
    }
    if(_data.completed){
      revert alreadyCompleted();
    }

    Level _level = Level(_data.level);
    if(_level.validateInstance(_instance)){
      uint _timeBonus;
      if(_data.timeBonus > 0){
          _timeBonus = _data.timeBonus; 
          _data.timeBonus--;
      }
      _data.completed = true;
      totalPointsPerPlayer[_data.player] += (_data.points + _timeBonus);
      emit LevelCompletedLog(msg.sender,_data.level);
    }
  }

  function applyForFirstPlace() external whenNotPaused {
      if(totalPointsPerPlayer[msg.sender] > totalPointsPerPlayer[winner]){
          winner = msg.sender;
      }
  }

  function registerLevel(address _level) external onlyOwner {
    registeredLevels[_level] = true;
  }

}
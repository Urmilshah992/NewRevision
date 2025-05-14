// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleStorage} from "./simpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }
    function sFstore(uint256 _simpleStorageIndex, uint256 _newSimplestorgeNumber)public{
        SimpleStorage mySimpleStorage = simpleStorageArray[_simpleStorageIndex];
        mySimpleStorage.store(_newSimplestorgeNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        SimpleStorage mySimpleStorage = simpleStorageArray[_simpleStorageIndex];
        return mySimpleStorage.retrieve();
    }


}


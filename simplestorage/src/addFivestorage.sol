// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleStorage} from "./simpleStorage.sol";
contract addFiveStorage is SimpleStorage {

 function store(uint256 _favoriteNumber) public override {
        myFavoriteNumber = _favoriteNumber + 5;}
}
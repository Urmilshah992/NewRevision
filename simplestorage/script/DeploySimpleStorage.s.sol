//SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script}  from "forge-std/Script.sol";
import {SimpleStorage} from "../src/simpleStorage.sol";
contract DeploySimpleStorage is Script{
    SimpleStorage public simplestorage;
    function run() public returns(SimpleStorage){
        vm.startBroadcast();
        simplestorage = new SimpleStorage();
        vm.stopBroadcast();
        return simplestorage;
    }

}
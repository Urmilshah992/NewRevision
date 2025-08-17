// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Raffel} from "src/Raffel.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeployRaffel is Script {
    function run() public {}

    function deployContract() public returns (Raffel, HelperConfig) {
        HelperConfig helperconfig = new HelperConfig();
    }
}

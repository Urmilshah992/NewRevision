// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Raffel} from "src/Raffel.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeployRaffel is Script {
    function run() public {}

    function deployContract() public returns (Raffel, HelperConfig) {
        HelperConfig helperconfig = new HelperConfig();
        // local -> deploy mock-> get local config
        // spolia -> get spolia config
        HelperConfig.NetworkConfig memory config = helperconfig.getConfig(); 


        vm.startBroadcast();
        Raffel raffel = new Raffel(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.gasLine,
            config.subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();
        return(raffel, helperconfig);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script,console} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from  "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";




contract CreateSubscription is Script{

    function createSubscriptionUsingPublic() public{
        HelperConfig helperconfig = new HelperConfig();
        address vrfCoordinator = helperconfig.getConfig().vrfCoordinator;
        createSubscription(vrfCoordinator);
    }

    function createSubscription(address vrfCoordinator) public {
        console.log("Creating subscription on vrfCoordinator:",vrfCoordinator);
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock(vrfCoordinator).createSubscription();
        vm.stopBroadcast();

    }
    function run() public{
        createSubscriptionUsingPublic(); 

    }

}
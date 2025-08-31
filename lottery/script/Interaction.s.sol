// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script, console} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingPublicF() public returns (uint256, address) {
        HelperConfig helperconfig = new HelperConfig();
        address vrfCoordinator = helperconfig.getConfig().vrfCoordinator;
        (uint256 subId,) = createSubscriptionF(vrfCoordinator);
        return (subId, vrfCoordinator);
    }

    function createSubscriptionF(address vrfCoordinator) public returns (uint256, address) {
        console.log("Creating subscription on vrfCoordinator:", vrfCoordinator);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator).createSubscription();
        vm.stopBroadcast();
        console.log("your subID is:", subId);
        console.log("Please update the SubID in the HelperConfig.s.sol and reDeply");
        return (subId, vrfCoordinator);
    }

    function run() public {
        createSubscriptionUsingPublicF();
    }
}

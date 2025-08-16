// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {DeployRaffel} from "script/DeployRaffel.s.sol";

contract HelperConfig {

    struct NetworkConfig{
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLine;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
    }

    NetworkConfig public localNetworkConfig;

    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor(){
        networkConfigs[11155111] = getSpoliaNetworkConfig(); // Sepolia Network
    }


    function getSpoliaNetworkConfig() public pure returns(NetworkConfig memory){
        return NetworkConfig({
            entranceFee : 0.01 ether, //1e16
            interval : 30, //30 seconds
            vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B, // Sepolia VRF Cooridinator
            gasLine: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae, // Sepolia gas line
            subscriptionId: 0, // Subscription ID for Sepolia
            callbackGasLimit: 500000 // 500,000 gas limit for callback 
            });
    }
 
}
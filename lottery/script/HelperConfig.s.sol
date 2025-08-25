// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract ConstVlue {
    //Mock Variables
    uint96 public constant MOCK_BASE_FEE = 0.25 ether;
    uint96 public constant MOCK_GAS_PRICE = 1e9; // 1 Gwei
    //link /eth Price
    int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;

    //chain id
    uint256 public constant ETH_SPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;

    function checkTheabstract() public pure returns (string memory) {}
}

contract HelperConfig is ConstVlue, Script {
    error HelperConfig__InvalidChainId(uint256 chainId);

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLine;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
    }

    NetworkConfig public localNetworkConfig;

    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[ETH_SPOLIA_CHAIN_ID] = getSpoliaNetworkConfig(); // Sepolia Network
    }

    function getConfigByChainId(uint256 chainid) public returns (NetworkConfig memory) {
        if (networkConfigs[chainid].vrfCoordinator == address(0)) {
            return networkConfigs[chainid];
        } else if (chainid == LOCAL_CHAIN_ID) {
            return getAnvilNetwrokConfig();
        } else {
            revert HelperConfig__InvalidChainId(chainid);
        }
    }

    function getConfig() public returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getSpoliaNetworkConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            entranceFee: 0.01 ether, //1e16
            interval: 30, //30 seconds
            vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B, // Sepolia VRF Cooridinator
            gasLine: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae, // Sepolia gas line
            subscriptionId: 0, // Subscription ID for Sepolia
            callbackGasLimit: 500000 // 500,000 gas limit for callback
        });
    }

    function getAnvilNetwrokConfig() public returns (NetworkConfig memory) {
        if (localNetworkConfig.vrfCoordinator != address(0)) {
            return localNetworkConfig;
        }

        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfcoordinatorMock =
            new VRFCoordinatorV2_5Mock(MOCK_BASE_FEE, MOCK_GAS_PRICE, MOCK_WEI_PER_UNIT_LINK);
        vm.stopBroadcast();

        localNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether, //1e16
            interval: 30, //30 seconds
            vrfCoordinator: address(vrfcoordinatorMock), //Local VRF Coordinator
            gasLine: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae, // Local gas line
            subscriptionId: 0, // Subscription ID for local network
            callbackGasLimit: 500000 // 500,000 gas limit for callback
        });

        return localNetworkConfig;
    }
}

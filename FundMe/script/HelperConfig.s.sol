// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8; // 2000 USD with 8 decimals
    
    NetworkConfig public activeNetworkConfig;
    struct NetworkConfig{
        address priceFeedAddress; //Eth/USD

    } 


    constructor() {
        if(block.chainid == 11155111) {
            //Sepolia
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if(block.chainid == 1) {
            //Mainnet
            activeNetworkConfig = getEthConfig();
        }
        else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        //priceFeedAddress of the Sepolia ETH/USd Price Feed
        NetworkConfig memory seploiaConfig = NetworkConfig({priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return seploiaConfig;
    }

      function getEthConfig() public pure returns (NetworkConfig memory){
        //priceFeedAddress of the Sepolia ETH/USd Price Feed
        NetworkConfig memory ethConfig = NetworkConfig({priceFeedAddress: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }

    function getAnvilEthConfig() public  returns (NetworkConfig memory){
        //priceFeedAddress of the Anvil ETH/USD Price Feed
        if(activeNetworkConfig.priceFeedAddress != address(0)){
            return activeNetworkConfig; // If already set, return the existing config
        }

            vm.startBroadcast();
            MockV3Aggregator mockv3aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE); // 2000 USD
            vm.stopBroadcast();
            NetworkConfig memory anvilConfig = NetworkConfig({priceFeedAddress: address(mockv3aggregator)});
            return anvilConfig;

    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;
import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    
    struct NetworkConfig{
        address priceFeedAddress; //Eth/USD

    } 

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if(block.chainid == 11155111) {
            //Sepolia
            activeNetworkConfig = getSepoliaEthConfig();
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

    function getAnvilEthConfig() public pure returns (NetworkConfig memory){
        //priceFeedAddress of the Anvil ETH/USD Price Feed

    }
}

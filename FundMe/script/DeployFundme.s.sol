// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol"; 
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{

    function run() external returns(FundMe){
        HelperConfig hconfig = new HelperConfig();
        address priceFeedAddress = hconfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeedAddress); // Chainlink ETH/USD Price Feed address on Sepolia 
        vm.stopBroadcast();
        return fundMe;
    }

}
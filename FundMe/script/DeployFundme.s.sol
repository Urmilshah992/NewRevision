// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol"; 

contract DeployFundMe is Script{
    function run() external returns(FundMe){
        vm.startBroadcast();
        FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); // Chainlink ETH/USD Price Feed address on Sepolia 
        vm.stopBroadcast();
        return fundMe;
    }

}
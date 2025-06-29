// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {FundMe} from "../src/fundme.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {DeployFundMe} from "../script/DeployFundme.s.sol";

contract FundMeTest is Test(){
    FundMe fundme;

    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
    }

    function testMinimumUSDcheckDoller() public view{
        assertEq(fundme.MINIMUMUSD(), 5e18);
    }

    function testOwner() public view{
        assertEq(fundme.i_owner(), msg.sender); // Check if the owner is the deployer
    }

    // function testwidraw() public{
    //     //arrange some fund
    //     uint256 fundamount = 10e18; // 10 ETH
    //     vm.deal(address(this), fundamount); // Give this contract 10 ETH
    //     fundme.fund{value: fundamount}(); // Fund the contract
    //     uint256 initialBalance = address(this).balance; // Get the initial balance of the contract
    //     //act
    //     fundme.withdraw(); // Withdraw the funds
    //     //assert
    //     uint256 finalBalance = address(this).balance; // Get the final balance of the contract
    //     assertEq(finalBalance, initialBalance + fundamount); // Check if the final balance is
    //     // equal to the initial balance plus the fund amount
    //     assertEq(fundme.fundersAmount(address(this)), 0); // Check if the amount funded by this contract is reset to 0
    // }


    function testgetversionAccurate() public view{
        uint256 version = fundme.getversion();
        console.log(version);
        assertEq(version, 4); // Check if the version is 4
    }

}
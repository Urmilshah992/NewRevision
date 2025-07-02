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


    function testgetversionAccurate() public view{
        uint256 version = fundme.getversion();
        console.log(version);
        assertEq(version, 4); // Check if the version is 4
    }

    function testFundFailWitoutEnoughFunds() public{
        vm.expectRevert("You need to spend more ETH!");
        fundme.fund{value:1e17}();

    }

}
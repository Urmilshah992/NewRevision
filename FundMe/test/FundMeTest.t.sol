// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {FundMe} from "../src/fundme.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {DeployFundMe} from "../script/DeployFundme.s.sol";

contract FundMeTest is Test(){
    FundMe fundme;

    address USER  = makeAddr("user");
    uint256 constant giveMoney = 0.1 ether;

    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
        vm.deal(USER,15e18); //Give some ETH to USER
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
        fundme.fund();
    }

    function testFundUpdateFundedAmount() public{
        vm.prank(USER); //Next TX will be sent  by USER
        fundme.fund{value:giveMoney}();
        uint256 fundedAmount = fundme.getAddressToAmountFunded(USER);
        console.log(fundedAmount);
        console.log(USER);
        assertEq(fundedAmount, giveMoney);
   //     assertEq(msg.sender,USER); // Check if the funded amount is 10e18
    }


    function testFunderArrayCheck() public {
        vm.prank(USER);
        fundme.fund{value:giveMoney}();
        address fundingaddress = fundme.getFunder(0);
        assertEq(fundingaddress,USER);
    }

    function testOwnerWithdraw() public{
        vm.prank(USER);
        fundme.fund{value:giveMoney}();

        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }
}
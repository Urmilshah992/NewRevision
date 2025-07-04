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
        assertEq(fundme.getOwner(), msg.sender); // Check if the owner is the deployer
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

    modifier funded(){
        vm.prank(USER);
        fundme.fund{value:giveMoney}();
        _;
    }

    function testOwnerWithdraw() public funded{
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }
    function testWithdrawOwner() public funded{
        //arrange
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;
        //act
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        //assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundmeBalance = address(fundme).balance;
        assertEq(endingFundmeBalance, 0); // Check if the FundMe contract
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);

    }
    function testWithDrawWithMultipleFunders() public funded{
        //arrange
        uint160 numberOfFunders = 10;
        uint160 staringIndex = 1;
        for(uint160 i = staringIndex; i< numberOfFunders; i++){
            hoax(address(i),giveMoney);
            fundme.fund{value:giveMoney}();
        }

        uint256 startingOwnerBalance = fundme.getOwner().balance;
        console.log(startingOwnerBalance);
        uint256 startingFundMeBalance = address(fundme).balance;
        console.log(startingFundMeBalance);

        //act
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        //assert
        assert(address(fundme).balance == 0);
        assert(fundme.getOwner().balance == startingOwnerBalance + startingFundMeBalance);
    }

}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {FundMe} from "../src/fundme.sol";
import {Test} from "forge-std/Test.sol";

contract FundMeTest is Test(){
    FundMe fundme;

    function setUp() external{
        fundme = new FundMe();
    }

    function testMinimumUSDcheckDoller() public view{
        assertEq(fundme.MINIMUMUSD(), 5e18);
    }

    function testOwner() public view{
        assertEq(fundme.i_owner(), address(this));
    }

}
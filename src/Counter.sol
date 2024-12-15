// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;
    uint256 public data = 0;

    function shouldAlwaysZero(uint256 dat1) public{
        if(dat1 == 2){
            data = dat1;  
        }
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }


}

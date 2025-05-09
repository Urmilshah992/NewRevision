// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;
    uint256 public data = 0;
    uint256 public hiddenvalue = 0;

    function shouldAlwaysZero(uint256 dat1) public {
        if (dat1 == 2) {
            data = 1;
        }
        if (hiddenvalue == 7) {
            data = 1;
        }

        hiddenvalue = dat1;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

    function convertabicode() public view returns (bytes memory) {
        bytes memory a = abi.encodePacked(data);
        return a;
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract CounterTest is StdInvariant, Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        targetContract(address(counter));
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function testShouldAlwaysZeroFuzz(uint256 y) public {
        counter.shouldAlwaysZero(y);
        assert(counter.data() == 0);
    }

    function invariant_testXy() public view {
        assert(counter.data() == 0);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Raffel} from "src/Raffel.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {Test} from "forge-std/Test.sol";
import {DeployRaffel} from "script/DeployRaffel.s.sol";

contract RaffelUnitTest is Test {
    Raffel public raffel;
    HelperConfig public helperconfig;

    address public PLAYER = makeAddr("player");
    uint256 public STARTING_BALANCE = 10 ether;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLine;
    uint256 subscriptionId;
    uint32 callbackGasLimit;

    function setUp() public {
        DeployRaffel deployer = new DeployRaffel();
        (raffel, helperconfig) = deployer.deployContract();

        HelperConfig.NetworkConfig memory config = helperconfig.getConfig();

        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLine = config.gasLine;
        subscriptionId = config.subscriptionId;
        callbackGasLimit = config.callbackGasLimit;
        vm.deal(PLAYER, STARTING_BALANCE);
    }

    function testRaffelInitializesInOpenState() public view {
        assert(raffel.getRaffelState() == Raffel.RaffelState.OPEN);
    }

    function testRaffelWhenyoudonthaveenoughEth() public {
        vm.prank(PLAYER);
        vm.expectRevert(Raffel.Raffel__NotEnoughEth.selector);
        raffel.enterRaffel();
    }

    function testplayersAddedToArray() public {
        //Arrange
        vm.prank(PLAYER);
        //Act
        raffel.enterRaffel{value: entranceFee}();
        address player = raffel.getPlayer(0);
        //Assert
        assert(player == PLAYER);
    }

    function testEmitsEventOnEntrance() public {
        //Arrange
        vm.prank(PLAYER);
        //Act
        vm.expectEmit(true, false, false, false, address(raffel));
        emit Raffel.RaffelEntered(PLAYER);

        //Assert
        raffel.enterRaffel{value: entranceFee}();
    }

    function testCantAlloedPlayerWhenRaffelIsCalculating() public{
        //Arrange
        vm.prank(PLAYER);
        raffel.enterRaffel{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        raffel.performUpkeep("");

        //Act & Assert
        vm.prank(PLAYER);
        vm.expectRevert(Raffel.Raffel__NotOpen.selector);
        raffel.enterRaffel{value: entranceFee}();

    }

}

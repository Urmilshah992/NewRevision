// SPDX-License-Identifier: MIT
pragma solidity >0.8.29;

/**
 * @title Raffel
 * @author Urmil Shah
 * @notice This contract is Sample Raffel Contract
 */
contract Raffel{

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee){
        i_entranceFee = entranceFee;
    }

    function enterRaffel() public payable{}

    function pickWiner() public {}

    /**Geter Function */

    function getEntrancefee() external view returns(uint256){
        return i_entranceFee;
    }

}
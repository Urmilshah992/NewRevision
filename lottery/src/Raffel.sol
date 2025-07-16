// SPDX-License-Identifier: MIT
pragma solidity >0.8.29;

/**
 * @title Raffel
 * @author Urmil Shah
 * @notice This contract is Sample Raffel Contract
 */
contract Raffel{
    /* Custom Error    */
    error Raffel__NotEnoughEth();

    /* State Variables */
    uint256 private immutable i_entranceFee;
    address payable[] private s_players; 


    constructor(uint256 entranceFee){
        i_entranceFee = entranceFee;
    }

    function enterRaffel() public payable{
         if(msg.value<i_entranceFee){
            //Revert the transaction if the user has not sent enough ETH`
            revert Raffel__NotEnoughEth();
            }
        //Add the player to the players array
        s_players.push(payable(msg.sender));    
    }
   

    function pickWiner() public {}

    /**Geter Function */

    function getEntrancefee() external view returns(uint256){
        return i_entranceFee;
    }

}
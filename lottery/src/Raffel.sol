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
    uint256 private immutable i_interval;
    uint256 private s_lastTimestamp;


    /* Events  */
    event RaffelEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval){
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimestamp = block.timestamp;

    }

    function enterRaffel() public payable{
         if(msg.value<i_entranceFee){
            //Revert the transaction if the user has not sent enough ETH`
            revert Raffel__NotEnoughEth();
            }
        //Add the player to the players array
        s_players.push(payable(msg.sender));   
        //Emit an event
        emit RaffelEntered(msg.sender);

    }
   

    function pickWiner() public {
        if(block.timestamp-s_lastTimestamp <i_interval){

        }
    }

    /**Geter Function */

    function getEntrancefee() external view returns(uint256){
        return i_entranceFee;
    }

}
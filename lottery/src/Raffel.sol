// SPDX-License-Identifier: MIT
pragma solidity >0.8.29;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
/**
 * @title Raffel
 * @author Urmil Shah
 * @notice This contract is Sample Raffel Contract
 */

contract Raffel is VRFConsumerBaseV2Plus {
    /* Custom Error    */
    error Raffel__NotEnoughEth();
    error Reffel__FieldTransfer();
    error Raffel__NotOpen();

    /* Type Declaration*/
    enum RaffelState {
        OPEN,
        CALCULATING
    }

    /* State Variables */
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    address payable[] private s_players;
    uint256 private s_lastTimestamp;
    address private s_recentWinner;
    RaffelState private s_raffelState;

    /* Events  */
    event RaffelEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLine,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_keyHash = gasLine;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_lastTimestamp = block.timestamp;
        s_raffelState = RaffelState.OPEN;
    }

    function enterRaffel() public payable {
        if (msg.value < i_entranceFee) {
            //Revert the transaction if the user has not sent enough ETH`
            revert Raffel__NotEnoughEth();
        }

        if (s_raffelState != RaffelState.OPEN) {
            revert Raffel__NotOpen();
        }
        //Add the player to the players array
        s_players.push(payable(msg.sender));
        //Emit an event
        emit RaffelEntered(msg.sender);
    }

    function pickWiner() public {
        if (block.timestamp - s_lastTimestamp < i_interval) {
            revert();
        }

        s_raffelState = RaffelState.CALCULATING;
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: i_keyHash,
            subId: i_subscriptionId,
            requestConfirmations: REQUEST_CONFIRMATIONS,
            callbackGasLimit: i_callbackGasLimit,
            numWords: NUM_WORDS,
            extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
        });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;
        s_raffelState = RaffelState.OPEN;

        //Reset The Palyers Array
        s_players = new address payable[](0);
        s_lastTimestamp = block.timestamp;

        //Transfer the balance to the winner
        (bool success,) = winner.call{value: address(this).balance}("");
        if (!success) {
            revert Reffel__FieldTransfer();
        }

        emit WinnerPicked(s_recentWinner);
    }

    /**
     * Geter Function
     */
    function getEntrancefee() external view returns (uint256) {
        return i_entranceFee;
    }
}

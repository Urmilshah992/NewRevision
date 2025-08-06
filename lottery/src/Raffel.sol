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

    /* State Variables */
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    address payable[] private s_players;
    uint256 private s_lastTimestamp;

    /* Events  */
    event RaffelEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval, address vrfCoordinator) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimestamp = block.timestamp;
    }

    function enterRaffel() public payable {
        if (msg.value < i_entranceFee) {
            //Revert the transaction if the user has not sent enough ETH`
            revert Raffel__NotEnoughEth();
        }
        //Add the player to the players array
        s_players.push(payable(msg.sender));
        //Emit an event
        emit RaffelEntered(msg.sender);
    }

    function pickWiner() public {
        if (block.timestamp - s_lastTimestamp < i_interval) {}
        revert();
        
           VRFV2PlusClient.RandomWordsRequest request =  VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            });
             uint256 requestId = s_vrfCoordinator.requestRandomWords(
                request
        );
    }

    /**
     * Geter Function
     */
    function getEntrancefee() external view returns (uint256) {
        return i_entranceFee;
    }
}

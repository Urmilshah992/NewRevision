//SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {PriceConvertor} from "./PriceConvertor.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


error FundMe_NotOwner();

contract FundMe {

    using PriceConvertor for uint256;
    uint256 public constant MINIMUMUSD = 5e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public fundersAmount;
    address public immutable  i_owner;
    AggregatorV3Interface public s_priceFeed;
    
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }
    function fund() public payable{
        //1e18 = 1ETH = 1000000000000000000 wei
        //1e18 = 10000000000 Gwei (Gas Cost Count)
        require(msg.value.getConversionRate(s_priceFeed) > MINIMUMUSD, "You need to spend more ETH!");
        funders.push(msg.sender);
        fundersAmount[msg.sender] += msg.value;
    }

    function getversion() public view returns (uint256){

        return s_priceFeed.version();
        
    }
    function withdraw() public onlyOwner {
        
        for (uint256 funderIndex = 0; funderIndex< funders.length; funderIndex++){
            address funder = funders[funderIndex];
            fundersAmount[funder] = 0; // Reset the amount funded for each funder
            
        }
        // Reset the funders array
        funders = new address[] (0);
        //Transfer the balance to the contract owner
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }   

    modifier onlyOwner(){
        // require(msg.sender == i_owner, "Only owner can call this function");
        if(msg.sender != i_owner) {
            revert FundMe_NotOwner();
        }
        _;
    }
     //What happens if by mistake the user sends money to the contract?
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

}
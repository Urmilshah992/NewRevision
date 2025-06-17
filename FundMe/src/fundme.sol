//SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract FundMe{
    uint256 public minimumUSD = 5e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public fundersAmount;
    function fund() public payable{
        //1e18 = 1ETH = 1000000000000000000 wei
        //1e18 = 10000000000 Gwei (Gas Cost Count)
        require(msg.value >   1e18, "You need to spend more ETH!");
        funders.push(msg.sender);
        fundersAmount[msg.sender] += msg.value;
    }

    function withdraw() public {
    }   
     function getPrice()public view return{
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);

     }  
     function getConversionRate(uint256 ethUSD) public view returns(uint256) {
        uint256 ethPrice =getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethUSD) / 1e18;
        return ethAmountInUSD;
     }
}
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;
import {PriceConvertor} from "./PriceConvertor.sol";
contract FundMe{
    using Priceconvertor for uint256;
    uint256 public minimumUSD = 5e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public fundersAmount;
    function fund() public payable{
        //1e18 = 1ETH = 1000000000000000000 wei
        //1e18 = 10000000000 Gwei (Gas Cost Count)
        require(msg.value.getConversionRate() >   1e18, "You need to spend more ETH!");
        funders.push(msg.sender);
        fundersAmount[msg.sender] += msg.value;
    }

    function withdraw() public {
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

}
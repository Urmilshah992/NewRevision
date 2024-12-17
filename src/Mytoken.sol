// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Mytoken is ERC20 { 
     uint256 public number1 = 1;
        uint256  public number2 = 2 ;
        uint256 public constant number3  = 3;
    constructor() ERC20("Urmil","UBS") {
       


    }
    
} 



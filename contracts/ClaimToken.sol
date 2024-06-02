// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ClaimToken {
    address public admin;
    ERC20 public tokenToClaim;
    mapping(address => uint256) public claimedTokens;

    constructor(address _tokenToClaim) {
        admin = msg.sender;
        tokenToClaim = ERC20(_tokenToClaim);
    }

    function claim(uint256 amount) public {
        require(msg.sender!= admin, "Admin cannot claim tokens");
        tokenToClaim.transferFrom(admin, msg.sender, amount);
        claimedTokens[msg.sender] += amount;
    }
}
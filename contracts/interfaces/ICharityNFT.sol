// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ICharityNFT  {
    
    function awardItem(address investor, string memory tokenURI) external returns(uint256);
}
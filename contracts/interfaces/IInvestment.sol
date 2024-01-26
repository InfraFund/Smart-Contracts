// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IInvestment {

    function invest(string memory _hashProposal, uint256 _amount) external;
}

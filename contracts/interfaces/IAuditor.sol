// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAuditor {

    function verifyClientProposal(string memory _hashProposal) external;
}

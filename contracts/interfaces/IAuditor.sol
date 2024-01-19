// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAuditor {

    function verifyProposal(string memory _hashProposal) external;
}

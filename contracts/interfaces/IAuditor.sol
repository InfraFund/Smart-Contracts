// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAuditor {

    event VerifyProposal(address indexed auditor, string indexed _hashProposal);

    function verifyProposla(string memory _hashProposal) external;
}

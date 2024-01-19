// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICharityProposal {
    
    event RegisterCharityProposal(string indexed _symbol, bytes32 indexed _hashProposal);
    event ModifyCharityProposal(bytes32 indexed _oldHashProposal, bytes32 indexed _newHashProposal);

    function registerCharityProposal(string memory _name, string memory _symbol, bytes32 _hashProposal) external;
    function modifyCharityProposal(bytes32 _oldHashProposal, bytes32 _newHashProposal) external;
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICharityProposal {
    
    function registerCharityProposal(
        string memory _name,
        string memory _symbol,
        string memory _hashProposal,
        address _GC,
        uint256 _targetAmount,
        uint256 _startTime,
        uint256 _duration 
        ) external;
    function modifyCharityProposal(
        string memory _oldHashProposal,
        string memory _newHashProposal,
        address _GC,
        uint256 _targetAmount,
        uint256 _startTime,
        uint256 _duration 
        ) external;
}

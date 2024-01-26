// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";

interface ICharityProposal {
    
    function registerCharityProposal(
        string memory _name,
        string memory _symbol,
        string memory _hashProposal,
        uint256 _investmentPeriod, 
        uint256 _targetAmount,
        address _GC,
        LibInfraFundStorage.GCStages[] memory _stages
        ) external;

    function modifyCharityProposal(
        string memory _oldHashProposal, 
        string memory _newHashProposal,
        uint256 _investmentPeriod,
        uint256 _targetAmount,
        address _GC,
        LibInfraFundStorage.GCStages[] memory _stages
        ) external;
}
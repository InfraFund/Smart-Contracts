// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";

interface ICharityPortal {
    
    function registerCharityProposal(
        string memory _name,
        string memory _symbol,
        string memory _hashProposal,
        uint256 _investmentPeriod, 
        uint256 _targetAmount,
        address _gc,
        LibInfraFundStorage.GCStages[] memory _stages
        ) external;

    function modifyCharityProposal(
        string memory _oldHashProposal, 
        string memory _newHashProposal,
        uint256 _investmentPeriod,
        uint256 _targetAmount,
        address _gc,
        LibInfraFundStorage.GCStages[] memory _stages
        ) external;

    function verifyCharityProposal(string memory _hashProposal, string memory tokenURI) external;
}
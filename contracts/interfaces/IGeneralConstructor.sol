// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";

interface IGeneralConstructor {
    
    function registerGCProposal(
        string memory _hashProposal,
        LibInfraFundStorage.GCStages[] memory stages,
        uint256 _totalNeedFund,
        uint256 _totalProposedTime
        ) external;

}

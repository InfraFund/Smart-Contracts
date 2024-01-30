// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";

interface IGeneralConstructor {
    
    function claimStageFundByGC(string memory _hashProject, uint256 _stage) external;

}

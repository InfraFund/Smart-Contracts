// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";
import { IAuditor } from "../interfaces/IAuditor.sol";

contract Auditor is IAuditor { 

    event VerifyProposal(address indexed auditor, string indexed _hashProposal);

    function verifyProposal(string memory _hashProposal) external {
            
        require(LibInfraFundStorage.isAuditor(msg.sender), "Your Not Auditor");
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified, "Your proposal already verified");

        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified = true;

        emit VerifyProposal(msg.sender, _hashProposal);
    }

}

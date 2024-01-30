// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";
import { IAuditor } from "../interfaces/IAuditor.sol";

contract Auditor is IAuditor {

    event VerifyProposal(address indexed auditor, string indexed _hashProposal);

    function verifyClientProposal(string memory _hashProposal) external {
            
        require(LibInfraFundStorage.isAuditor(msg.sender), "Your Not Auditor");
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified, "Your proposal already verified");
        require(
            LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].investmentPeriod + LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].investmentPeriod < block.timestamp, 
            "This Proposal Has Expired");

        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified = true;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].investmentPeriod = block.timestamp;

        emit VerifyProposal(msg.sender, _hashProposal);
    }

}

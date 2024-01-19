// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibInfraFundStorage} from "../libraries/LibInfraFundStorage.sol";

contract Auditor {

    event VerifyProposal(address indexed auditor, string indexed _hashProposal);

    function verifyProposla(string memory _hashProposal) external {
            
        LibInfraFundStorage.InfraFundStorage storage infraStorage = LibInfraFundStorage.infraFundStorage();

        require(infraStorage.auditors[msg.sender], "Your Not Auditor");
        require(!infraStorage.charityProjects[_hashProposal].isVerified, "Your proposal already verified");

        infraStorage.charityProjects[_hashProposal].isVerified = true;

        emit VerifyProposal(msg.sender, _hashProposal);
    }

}

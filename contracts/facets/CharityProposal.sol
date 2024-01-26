// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";
import { ICharityProposal } from "../interfaces/ICharityProposal.sol";

contract  CharityProposal is ICharityProposal {

    event RegisterCharityProposal(string indexed _symbol, string indexed _hashProposal);
    event ModifyCharityProposal(string indexed _oldHashProposal, string indexed _newHashProposal);

    function registerCharityProposal(
        string memory _name,
        string memory _symbol,
        string memory _hashProposal,
        uint256 _investmentPeriod, 
        uint256 _targetAmount
        ) external {
            
        require(LibInfraFundStorage.infraFundStorage().verifiedClients[msg.sender], "Not White Listed");
        
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal] = LibInfraFundStorage.CharityProject(
            _name,
            _symbol,
            msg.sender,
            address(0), 
            address(0),
            0,
            _investmentPeriod,
            _targetAmount,
            false
        );
        LibInfraFundStorage.infraFundStorage().proposals.push(_hashProposal);
        
        emit RegisterCharityProposal(_symbol, _hashProposal);
    }

    function modifyCharityProposal(
        string memory _oldHashProposal, 
        string memory _newHashProposal,
        uint256 _investmentPeriod,
        uint256 _targetAmount
        ) external {

        require(LibInfraFundStorage.infraFundStorage().verifiedClients[msg.sender], "Not White Listed");
        require(LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].proposer == msg.sender, "You are not proposer for this proposal");
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].isVerified, "Your proposal already verified , cant change current proposal");

        LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].investmentPeriod = _investmentPeriod;
        LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].targetAmount = _targetAmount;

        emit ModifyCharityProposal(_oldHashProposal, _newHashProposal);
    }


}

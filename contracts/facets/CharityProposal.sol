// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibInfraFundStorage} from "../libraries/LibInfraFundStorage.sol";

contract CharityProposal {

    event RegisterCharityProposal(string indexed _symbol, string indexed _hashProposal);
    event ModifyCharityProposal(string indexed _oldHashProposal, string indexed _newHashProposal);


    function registerCharityProposal(
        string memory _name,
        string memory _symbol,
        string memory _hashProposal,
        uint256 _targetAmount,
        uint256 _startTime,
        uint256 _expireTime 
        ) external {
            
        LibInfraFundStorage.InfraFundStorage storage infraStorage = LibInfraFundStorage.infraFundStorage();

        require(infraStorage.verifiedClients[msg.sender], "Not White Listed");

        infraStorage.charityProjects[_hashProposal] = LibInfraFundStorage.CharityProject(
            _name,
            _symbol,
            msg.sender,
            address(0),
            address(0),
            _startTime,
            _expireTime,
            _targetAmount,
            false
        );
        infraStorage.proposals.push(_hashProposal);
        
        emit RegisterCharityProposal(_symbol, _hashProposal);
    }

    function modifyCharityProposal(string memory _oldHashProposal, string memory _newHashProposal) external {
        LibInfraFundStorage.InfraFundStorage storage infraStorage = LibInfraFundStorage.infraFundStorage();

        require(infraStorage.verifiedClients[msg.sender], "Not White Listed");
        require(infraStorage.charityProjects[_oldHashProposal].proposer == msg.sender, "You are not proposer for this proposal");
       
        infraStorage.charityProjects[_newHashProposal] = infraStorage.charityProjects[_oldHashProposal];
        
        emit ModifyCharityProposal(_oldHashProposal, _newHashProposal);
    }


}

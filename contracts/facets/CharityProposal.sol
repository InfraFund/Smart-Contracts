// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";
import { ICharityProposal } from "../interfaces/ICharityProposal.sol";
import { IERC20 } from "../interfaces/IERC20.sol";

contract  CharityProposal is ICharityProposal {

    event RegisterCharityProposal(string indexed _hashProposal, address indexed _gc);
    event ModifyCharityProposal(string indexed _oldHashProposal, string indexed _newHashProposal);

    function registerCharityProposal(
        string memory _name,
        string memory _symbol,
        string memory _hashProposal,
        uint256 _investmentPeriod, 
        uint256 _targetAmount,
        address _gc,
        LibInfraFundStorage.Stages[] memory _stages
        ) external {
        
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].exist, "This Proposal Hash Already Exist");
        require(LibInfraFundStorage.isVerifiedClient(msg.sender), "Client Is Not Verified");
        require(LibInfraFundStorage.isGC(_gc), "GC Is Not Verified");
        
        IERC20(LibInfraFundStorage.infraFundStorage().tokenPayment).transferFrom(msg.sender, address(this), LibInfraFundStorage.infraFundStorage().proposalFee);

        LibInfraFundStorage.GCStages[] memory stages; 
        
        for(int i=0; i < _stages.length(); i++ ) {
            stages.push(
                LibInfraFundStorage.GCStages(
                    _stages[i].neededFund, 
                    _stages[i].proposedTime,
                    0,
                    false,
                    false,
                    false,
                    false
                )
            )
        }
        
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal] = LibInfraFundStorage.CharityProject(
            _name,
            _symbol,
            msg.sender,
            address(0), 
            _gc,
            0,
            _investmentPeriod,
            _targetAmount,
            stages,
            false
        );
        
        LibInfraFundStorage.infraFundStorage().proposals.push(_hashProposal);
        LibInfraFundStorage.infraFundStorage().projectType[_hashProposal] = LibInfraFundStorage.CHARITY;
        
        emit RegisterCharityProposal(_hashProposal, _gc);
    }

    function modifyCharityProposal(
        string memory _oldHashProposal, 
        string memory _newHashProposal,
        uint256 _investmentPeriod,
        uint256 _targetAmount,
        address _gc,
        LibInfraFundStorage.Stages[] memory _stages
        ) external {

        require(LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].exist, "This Proposal Hash Not Exist");
        require(LibInfraFundStorage.infraFundStorage().verifiedClients[msg.sender], "Client Is Not Verified");
        require(LibInfraFundStorage.isGC(_gc), "GC Is Not Verified");
        require(LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].proposer == msg.sender, "You are not proposer for this proposal");
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].isVerified, "Your proposal already verified , cant change current proposal");

        LibInfraFundStorage.CharityProject memory tmp = LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal];

        LibInfraFundStorage.GCStages[] memory stages; 
        
        for(int i=0; i < _stages.length(); i++ ) {
            stages.push(
                LibInfraFundStorage.GCStages(
                    _stages[i].neededFund, 
                    _stages[i].proposedTime,
                    0,
                    false,
                    false,
                    false,
                    false
                )
            )
        }

        tmp.investmentPeriod = _investmentPeriod;
        tmp.targetAmount = _targetAmount;
        tmp.gc = _gc;
        tmp.stages = stages;

        LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal] = tmp;

        emit ModifyCharityProposal(_oldHashProposal, _newHashProposal);
    }


}

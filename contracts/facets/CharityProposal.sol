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

        
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].name = _name;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].symbol = _symbol;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].proposer = msg.sender;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].contractAddress = address(0);
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].gc = _gc;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].startTime = 0;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].investmentPeriod = _investmentPeriod;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].targetAmount = _targetAmount;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified = false;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].exist = true;

        for(uint8 i=0; i < _stages.length; i++ ) {
            LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].stages[i] = LibInfraFundStorage.GCStages(
                    _stages[i].neededFund, 
                    _stages[i].proposedTime,
                    0,
                    false,
                    false,
                    false,
                    false
            );
        }

        LibInfraFundStorage.infraFundStorage().proposals.push(_hashProposal);
        LibInfraFundStorage.infraFundStorage().projectType[_hashProposal] = LibInfraFundStorage.infraFundStorage().CHARITY;
        
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

        require(LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].exist, "This Proposal Hash Not Exist");
        require(LibInfraFundStorage.infraFundStorage().verifiedClients[msg.sender], "Client Is Not Verified");
        require(LibInfraFundStorage.isGC(_gc), "GC Is Not Verified");
        require(LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].proposer == msg.sender, "You are not proposer for this proposal");
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].isVerified, "Your proposal already verified , cant change current proposal");

        for(uint8 i=0; i < _stages.length; i++ ) {
            LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal].stages[i] = LibInfraFundStorage.GCStages(
                    _stages[i].neededFund, 
                    _stages[i].proposedTime,
                    0,
                    false,
                    false,
                    false,
                    false
            );
        }
        

        LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal].investmentPeriod = _investmentPeriod;
        LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal].targetAmount = _targetAmount;
        LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal].gc = _gc;

        emit ModifyCharityProposal(_oldHashProposal, _newHashProposal);
    }


}

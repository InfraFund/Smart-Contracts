// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";
import { ICharityProposal } from "../interfaces/ICharityProposal.sol";
import { IERC20 } from "../interfaces/IERC20.sol";

contract  CharityProposal is ICharityProposal {

    event RegisterCharityProposal(string indexed _symbol, string indexed _hashProposal);
    event ModifyCharityProposal(string indexed _oldHashProposal, string indexed _newHashProposal);

    function registerCharityProposal(
        string memory _name,
        string memory _symbol,
        string memory _hashProposal,
        uint256 _investmentPeriod, 
        uint256 _targetAmount,
        address _GC,
        LibInfraFundStorage.GCStages[] memory _stages
        ) external {
        
        require(LibInfraFundStorage.isVerifiedClient(msg.sender), "Client Is Not Verified");
        require(LibInfraFundStorage.isGC(_GC), "GC Is Not Verified");
        
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal] = LibInfraFundStorage.CharityProject(
            _name,
            _symbol,
            msg.sender,
            address(0), 
            address(0),
            0,
            _investmentPeriod,
            _targetAmount,
            _stages,
            false
        );
        
        IERC20(LibInfraFundStorage.infraFundStorage().tokenPayment).transferFrom(msg.sender, address(this), LibInfraFundStorage.infraFundStorage().proposalFee);

        LibInfraFundStorage.infraFundStorage().proposals.push(_hashProposal);
        
        emit RegisterCharityProposal(_symbol, _hashProposal);
    }

    function modifyCharityProposal(
        string memory _oldHashProposal, 
        string memory _newHashProposal,
        uint256 _investmentPeriod,
        uint256 _targetAmount,
        address _GC,
        LibInfraFundStorage.GCStages[] memory _stages
        ) external {

        require(LibInfraFundStorage.infraFundStorage().verifiedClients[msg.sender], "Client Is Not Verified");
        require(LibInfraFundStorage.isGC(_GC), "GC Is Not Verified");
        require(LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].proposer == msg.sender, "You are not proposer for this proposal");
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].isVerified, "Your proposal already verified , cant change current proposal");

        LibInfraFundStorage.CharityProject memory tmp = LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal];

        tmp.investmentPeriod = _investmentPeriod;
        tmp.targetAmount = _targetAmount;
        tmp.GC = _GC;
        tmp.stages = _stages;

        LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal] = tmp;

        emit ModifyCharityProposal(_oldHashProposal, _newHashProposal);
    }


}

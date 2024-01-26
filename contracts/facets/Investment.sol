// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";
import { IInvestment } from "../interfaces/IInvestment.sol";
import { IERC20 } from "../interfaces/IERC20.sol";

contract Investment is IInvestment { 

    event Invest(string indexed hashProposal, address indexed investor, uint256 amount);

    function invest(string memory _hashProposal, uint256 _amount) external {
            
        require(LibInfraFundStorage.isInvestor(msg.sender), "Your Not Investor");
        require(LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified, "The Proposal Is Not Verified");
        require(
            LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].startTime + LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].investmentPeriod < block.timestamp, 
            "Investment Time Has Expired");

        IERC20(LibInfraFundStorage.infraFundStorage().tokenPayment).transferFrom(msg.sender, address(this), _amount);

        if (LibInfraFundStorage.infraFundStorage().amountOfInvestment[_hashProposal][msg.sender] == 0) {
            LibInfraFundStorage.infraFundStorage().listProjectsPerAddress[msg.sender].push(_hashProposal);
        }

        LibInfraFundStorage.infraFundStorage().amountOfInvestment[_hashProposal][msg.sender] += _amount;
        LibInfraFundStorage.infraFundStorage().projectBalance[_hashProposal] += _amount;

        emit Invest(_hashProposal, msg.sender, _amount);
    }

    function claimByGC(string memory _hashProject, uint16 _stage) external {

    }

}

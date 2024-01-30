// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";
import { IGeneralConstructor } from "../interfaces/IGeneralConstructor.sol";
import { IERC20 } from "../interfaces/IERC20.sol";

contract GeneralConstructor is IGeneralConstructor { 

    event ClaimStageFundByGC(string indexed _hashProject, uint256 indexed _stage);

    function claimStageFundByGC(string memory _hashProject, uint256 _stage) external {

        require(LibInfraFundStorage.isGC(msg.sender), "GC Is Not Verified");
        require(LibInfraFundStorage.infraFundStorage().projectType[_hashProject] != 0, "The Project Proposal Not Exist");


        if (LibInfraFundStorage.infraFundStorage().projectType[_hashProject] == LibInfraFundStorage.infraFundStorage().CHARITY) {
            
            require(LibInfraFundStorage.infraFundStorage().charityProjects[_hashProject].stages[_stage].isVerfied, "The Stage Claim Not Confirm By Auditor");
            require(_stage < LibInfraFundStorage.infraFundStorage().charityProjects[_hashProject].stages.length , "The Project Stage Number Not Exist");
            require(!LibInfraFundStorage.infraFundStorage().charityProjects[_hashProject].stages[_stage].isClaimed , "The Stage Already Claimed");

            IERC20(LibInfraFundStorage.infraFundStorage().tokenPayment).transferFrom(
                address(this), 
                msg.sender, 
                LibInfraFundStorage.infraFundStorage().charityProjects[_hashProject].stages[_stage].neededFund    
            );
            LibInfraFundStorage.infraFundStorage().charityProjects[_hashProject].stages[_stage].isClaimed = true;
        
        } else if (LibInfraFundStorage.infraFundStorage().projectType[_hashProject] == LibInfraFundStorage.infraFundStorage().LOAN) {
            
            require(LibInfraFundStorage.infraFundStorage().loanProjects[_hashProject].stages[_stage].isVerfied, "The Stage Claim Not Confirm By Auditor");
            require(_stage < LibInfraFundStorage.infraFundStorage().loanProjects[_hashProject].stages.length , "The Project Stage Number Not Exist");
            require(!LibInfraFundStorage.infraFundStorage().loanProjects[_hashProject].stages[_stage].isClaimed , "The Stage Already Claimed");
            
            IERC20(LibInfraFundStorage.infraFundStorage().tokenPayment).transferFrom(
                address(this), 
                msg.sender, 
                LibInfraFundStorage.infraFundStorage().loanProjects[_hashProject].stages[_stage].neededFund
            );
            LibInfraFundStorage.infraFundStorage().loanProjects[_hashProject].stages[_stage].isClaimed = true;
        
        } else if (LibInfraFundStorage.infraFundStorage().projectType[_hashProject] == LibInfraFundStorage.infraFundStorage().PRESALE) {
            
            require(LibInfraFundStorage.infraFundStorage().presaleProjects[_hashProject].stages[_stage].isVerfied, "The Stage Claim Not Confirm By Auditor");
            require(_stage < LibInfraFundStorage.infraFundStorage().presaleProjects[_hashProject].stages.length , "The Project Stage Number Not Exist");
            require(!LibInfraFundStorage.infraFundStorage().presaleProjects[_hashProject].stages[_stage].isClaimed , "The Stage Already Claimed");
            
            IERC20(LibInfraFundStorage.infraFundStorage().tokenPayment).transferFrom(
                address(this), 
                msg.sender, 
                LibInfraFundStorage.infraFundStorage().presaleProjects[_hashProject].stages[_stage].neededFund
            );
            LibInfraFundStorage.infraFundStorage().presaleProjects[_hashProject].stages[_stage].isClaimed = true;
        
        } else if (LibInfraFundStorage.infraFundStorage().projectType[_hashProject] == LibInfraFundStorage.infraFundStorage().SECURITY_TOKEN) {
            
            require(LibInfraFundStorage.infraFundStorage().securityProjects[_hashProject].stages[_stage].isVerfied, "The Stage Claim Not Confirm By Auditor");
            require(_stage < LibInfraFundStorage.infraFundStorage().securityProjects[_hashProject].stages.length , "The Project Stage Number Not Exist");
            require(!LibInfraFundStorage.infraFundStorage().securityProjects[_hashProject].stages[_stage].isClaimed , "The Stage Already Claimed");
            
            IERC20(LibInfraFundStorage.infraFundStorage().tokenPayment).transferFrom(
                address(this), 
                msg.sender, 
                LibInfraFundStorage.infraFundStorage().securityProjects[_hashProject].stages[_stage].neededFund
            );
            LibInfraFundStorage.infraFundStorage().securityProjects[_hashProject].stages[_stage].isClaimed = true;
        }

        emit ClaimStageFundByGC(_hashProject, _stage);
    }

    function requestExtraFundInStageByGC(string memory _hashProject, uint16 _stage, uint256 _extraAmount) external {

    }

    function claimExtraFundInStageByGC(string memory _hashProject, uint16 _stage, uint256 _extraAmount) external {

    }

}

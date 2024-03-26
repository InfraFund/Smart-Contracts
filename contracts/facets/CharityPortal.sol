// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";
import { ICharityPortal } from "../interfaces/ICharityPortal.sol";
import { IERC20 } from "../interfaces/IERC20.sol";
import { CharityContract } from "../tokens/CharityContract.sol";
import { CharityNFT } from "../tokens/ERC721.sol";
import { DiamondLoupeFacet } from "./DiamondLoupeFacet.sol";
import { UserData } from "./UserData.sol";

contract  CharityPortal is ICharityPortal {

    event RegisterCharityProposal(string indexed hashProposal, address indexed gc);
    event ModifyCharityProposal(string indexed oldHashProposal, string indexed newHashProposal);
    event VerifyCharityProposal(address indexed auditor, address indexed charityContractAddress, string indexed _hashProposal);

    function registerCharityProposal(
        string memory _name,
        string memory _symbol,
        string memory _hashProposal,
        uint256 _endOfInvestmentPeriodTime, 
        uint256 _targetAmountOfCapital,
        address _gc,
        LibInfraFundStorage.GCStages[] memory _stages
        ) external {
        
        require(LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].proposer == address(0), "This Proposal Hash Already Exist");
        require(LibInfraFundStorage.isVerifiedClient(msg.sender), "Client Is Not Verified");
        require(LibInfraFundStorage.isGC(_gc), "GC Is Not Verified");
        
        IERC20(LibInfraFundStorage.infraFundStorage().tokenPayment).transferFrom(msg.sender, address(this), LibInfraFundStorage.infraFundStorage().proposalFee);

        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].name = _name;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].symbol = _symbol;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].proposer = msg.sender;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].contractAddress = address(0);
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].nftAddress = address(0);
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].gc = _gc;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].endOfInvestmentPeriodTime = _endOfInvestmentPeriodTime;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].targetAmountOfCapital = _targetAmountOfCapital;
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified = false;

        for(uint8 i=0; i < _stages.length; i++ ) {
            LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].stages[i] = LibInfraFundStorage.GCStages(
                    _stages[i].neededFund, 
                    _stages[i].proposedFinishTime,
                    _stages[i].KPI
            );
        }

        LibInfraFundStorage.infraFundStorage().proposals.push(_hashProposal);
        LibInfraFundStorage.infraFundStorage().projectType[_hashProposal] = LibInfraFundStorage.infraFundStorage().CHARITY;
        
        emit RegisterCharityProposal(_hashProposal, _gc);
    }

    function modifyCharityProposal(
        string memory _oldHashProposal, 
        string memory _newHashProposal,
        uint256 _endOfInvestmentPeriodTime,
        uint256 _targetAmountOfCapital,
        address _gc,
        LibInfraFundStorage.GCStages[] memory _stages
        ) external {

        require(LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].proposer != address(0), "This Charity Proposal Hash Not Exist");
        require(LibInfraFundStorage.infraFundStorage().verifiedClients[msg.sender], "Client Is Not Verified");
        require(LibInfraFundStorage.isGC(_gc), "GC Is Not Verified");
        require(LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].proposer == msg.sender, "You Are Not Proposer For This Proposal");
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_oldHashProposal].isVerified, "After Verified ,Cant Change Proposal");

        for(uint8 i=0; i < _stages.length; i++ ) {
            LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal].stages[i] = LibInfraFundStorage.GCStages(
                    _stages[i].neededFund, 
                    _stages[i].proposedFinishTime,
                    _stages[i].KPI
            );
        }
        
        LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal].endOfInvestmentPeriodTime = _endOfInvestmentPeriodTime;
        LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal].targetAmountOfCapital = _targetAmountOfCapital;
        LibInfraFundStorage.infraFundStorage().charityProjects[_newHashProposal].gc = _gc;

        emit ModifyCharityProposal(_oldHashProposal, _newHashProposal);
    }

    function verifyCharityProposal(string memory _hashProposal, string memory _nftURI) external {

        require(LibInfraFundStorage.isAuditor(msg.sender), "Your Not Auditor");
        require(LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].proposer != address(0), "This Charity Proposal Hash Not Exist");
        require(!LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified, "This Proposal Already Verified");

        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].isVerified = true;

        CharityNFT nftContract = new CharityNFT(LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].name , LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].symbol);

        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].nftURI = _nftURI;
        
        CharityContract charityContract = new CharityContract(
            LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].targetAmountOfCapital,
            LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].endOfInvestmentPeriodTime,
            LibInfraFundStorage.AddressStruct(
                DiamondLoupeFacet.facetAddress(UserData.userDataConst.selector), 
                LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].proposer,
                address(nftContract),
                LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].gc,
                LibInfraFundStorage.infraFundStorage().tokenPayment
            ),
            LibInfraFundStorage.StringStruct(
                _hashProposal,
                LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].name,
                LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].symbol,
                LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].nftURI
            ),
            LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].stages
        );
        
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].contractAddress = address(charityContract);
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].nftAddress = address(nftContract);
        LibInfraFundStorage.infraFundStorage().charityProjects[_hashProposal].nftURI = nftURI;

        emit VerifyCharityProposal(msg.sender, address(charityContract), _hashProposal);
    }

}

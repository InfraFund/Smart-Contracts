// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "../interfaces/IERC20.sol";
import { IUserData } from "../interfaces/IUserData.sol";
// import { ICharityContract } from "../interfaces/ICharityContract.sol";
import { ICharityNFT } from "../interfaces/ICharityNFT.sol";
import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";

import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract CharityContract { 

    struct GCStages {
        uint256 neededFund;
        uint256 proposedFinishTime;
        uint256 KPI;
        uint256 neededExtraFund;
        string proposalHashForExtraFund;
        bool isClaimed;
        bool isVerfied;
        bool isClaimedExtraFund;
        bool isVerfiedExtraFund;
    }
    
    mapping(address => mapping(uint256 => bool)) private investorVote;
    mapping(uint256 =>  uint256) private numberOfVotesToAccept;
    uint256 totalInvstors;

    uint256 private targetAmountOfCapital;
    uint256 public endOfInvestmentPeriodTime;
    uint256 public currentCampaignBalance;
    uint256 public campaignStartTime;
    address private userFacetAddress;
    address public proposer;
    address public nftAddress;
    address public gcAddress;
    address public tokenPayment;
    string public hashProposal;
    string public symbol;
    string private nftURI;
    string public name;

    GCStages[] public stages;

    mapping(address => uint256) public investorBalance;
    mapping(address => bool) public investorClaimedNFT;
    bool public gcAgreement;

    event InvestmentToCharity(address indexed investor, uint256 amount);
    event ClaimedNFT(address indexed investor);
    event RevokeInvestment(address indexed investor);
    event SignAgreement(address indexed GC);
    event GCWithdraw(address indexed GC, uint256 indexed stage);
    event StageVerified(address indexed auditor, uint256 indexed stage);
    event RequestExtraFund(address indexed GC, uint256 indexed stage, string indexed hashPropoal, uint256 amount);
    event ExtraFundVerified(address indexed auditor, uint256 indexed stage);
    event ExtraFundWithdraw(address indexed GC, uint256 indexed stage);
    
    constructor(
        uint256 _targetAmountOfCapital,
        uint256 _endOfInvestmentPeriodTime,
        LibInfraFundStorage.AddressStruct memory addressStruct,
        LibInfraFundStorage.StringStruct memory stringStruct,
        LibInfraFundStorage.GCStages[] memory _stages
        ) {

        targetAmountOfCapital = _targetAmountOfCapital;
        endOfInvestmentPeriodTime = _endOfInvestmentPeriodTime;

        userFacetAddress = addressStruct.userFacetAddress;
        tokenPayment = addressStruct.tokenPayment;
        nftAddress = addressStruct.nftAddress;
        proposer = addressStruct.proposer;
        gcAddress = addressStruct.gc;

        hashProposal = stringStruct.hashProposal;
        nftURI = stringStruct.nftURI;
        symbol = stringStruct.symbol;
        name = stringStruct.name;

        for(uint256 i = 0; i < _stages.length; i += 1 ) {
            stages[i] = GCStages(
                _stages[i].neededFund,
                _stages[i].proposedFinishTime,
                _stages[i].KPI,
                0,
                "",
                false,
                false,
                false,
                false
            );
        }

        campaignStartTime = block.timestamp;
    }

    function invest(uint256 _amount) LibInfraFundStorage.InvestorOnly(msg.sender) external {

        require(_amount + currentCampaignBalance > targetAmountOfCapital, "Amount Is More Than Target Amount");
        require(block.timestamp > endOfInvestmentPeriodTime, "Investment Time Has Expired");

        if (investorBalance[msg.sender] == 0) {
            ICharityNFT(nftAddress).awardItem(msg.sender, nftURI);
        }

        investorBalance[msg.sender] += _amount;
        currentCampaignBalance += _amount;
        totalInvstors += 1;

        IERC20(tokenPayment).transferFrom(msg.sender, address(this), _amount);
        emit InvestmentToCharity(msg.sender, _amount);
    }

    function claimNFT() LibInfraFundStorage.InvestorOnly(msg.sender) external {

        require(endOfInvestmentPeriodTime <= block.timestamp, "Investment Time Not Complated");
        require(investorBalance[msg.sender] > 0, "Your Not Investor in this Project");
        require(!investorClaimedNFT[msg.sender], "Already NFT claimed");

        investorClaimedNFT[msg.sender] = true;
        ICharityNFT(nftAddress).awardItem(msg.sender, nftURI);

        emit ClaimedNFT(msg.sender);
    }

    function revokeInvestment() LibInfraFundStorage.InvestorOnly(msg.sender) external {
        
        require(block.timestamp > endOfInvestmentPeriodTime , "Investment Time Not Complated");
        require(investorBalance[msg.sender] > 0, "You'r not have a balance in this project");
        require(targetAmountOfCapital >= currentCampaignBalance , "Target reach to fund, cant revoke!");  

        investorBalance[msg.sender] = 0;
        IERC20(tokenPayment).transferFrom(msg.sender, address(this), investorBalance[msg.sender]);

        emit RevokeInvestment(msg.sender);
    }

    function verifySignature(bytes memory signature ) LibInfraFundStorage.GCOnly(msg.sender) external {

        require(targetAmountOfCapital < currentCampaignBalance , "Target not to reach fund");
        require(block.timestamp > endOfInvestmentPeriodTime , "Investment Time Not Complated");
        require(block.timestamp <= endOfInvestmentPeriodTime + 3 days , "Agreement time is expire");

        bytes32 hash = MessageHashUtils.toEthSignedMessageHash(hexAgreement());
        address recoveredSigner = ECDSA.recover(hash, signature);

        require(msg.sender == recoveredSigner, "Signature does not match with signer");
        gcAgreement = true;

        emit SignAgreement(msg.sender);
    }

    function verifyStage(uint256 _stage) LibInfraFundStorage.AuditorOnly(msg.sender) external {
        
        require(gcAgreement, "Agreement not signed by GC");
        require(_stage < stages.length, "Stage is not exists");
        require(!stages[_stage].isVerfied, "Stage is already verified");
        require(block.timestamp > stages[_stage].proposedFinishTime, "Stage is not finish");

        stages[_stage].isVerfied = true;

        emit StageVerified(msg.sender, _stage);
    }

    function withdrawByGC(uint256 _stage) LibInfraFundStorage.GCOnly(msg.sender) external {

        require(_stage < stages.length, "Stage is not exists");
        require(stages[_stage].isVerfied, "Stage is not verified");
        require(!stages[_stage].isClaimed, "Stage already claimed");

        stages[_stage].isClaimed = true;

        IERC20(tokenPayment).transferFrom(address(this), msg.sender, stages[_stage].neededFund);

        emit GCWithdraw(msg.sender, _stage);
    }

    function requestExtraFund(uint256 _stage, uint256 _extraFund, string memory _hashPropoal) LibInfraFundStorage.GCOnly(msg.sender) external {

        require(_stage < stages.length, "Stage is not exists");
        require(stages[_stage].isVerfied, "Stage is not verified yet!");
        require(stages[_stage].neededExtraFund == 0, "Already Requested!");

        stages[_stage].proposalHashForExtraFund = _hashPropoal;
        stages[_stage].neededExtraFund = _extraFund;

        emit RequestExtraFund(msg.sender, _stage, _hashPropoal, _extraFund);
    }

    function verifyExtraFund(uint256 _stage) LibInfraFundStorage.AuditorOnly(msg.sender) external {
        
        require(_stage < stages.length, "Stage is not exists");
        require(!stages[_stage].isVerfiedExtraFund, "Extrafund Already Verified");
        require(stages[_stage].neededExtraFund > 0, "Extrafund Not Requested");

        stages[_stage].isVerfiedExtraFund = true;
        emit ExtraFundVerified(msg.sender, _stage);
    }

    function acceptExtraFundProposalByInvestors(uint256 _stage) LibInfraFundStorage.InvestorOnly(msg.sender) external {
        
        require(investorBalance[msg.sender] > 0, "You Not Permission");
        require(_stage < stages.length, "This stage is not exists");
        require(stages[_stage].isVerfiedExtraFund, "This Extra fund stage is not verified");
        require(!investorVote[msg.sender][_stage], "You vote already");

        numberOfVotesToAccept[_stage] += 1;        
        investorVote[msg.sender][_stage] = true;
    }

    function withdrawExtraFundByGC(uint256 _stage) LibInfraFundStorage.GCOnly(msg.sender) external {
        
        require(_stage < stages.length, "Stage is not exists");
        require(stages[_stage].isVerfiedExtraFund, "ExtraFund Stage Not Verified");
        require(!stages[_stage].isClaimedExtraFund, "ExtraFund Stage Already Claimed");
        require(numberOfVotesToAccept[_stage] > totalInvstors / 2 , "Not Enough Votes");

        stages[_stage].isClaimedExtraFund = true;

        IERC20(tokenPayment).transferFrom(address(this), msg.sender, stages[_stage].neededExtraFund);
        emit ExtraFundWithdraw(msg.sender, _stage);
    }

    // =========== Read Data ===========

    function getNumberMilestons() external view returns(uint256) {
        return stages.length;
    }

    function hexAgreement() public pure returns(bytes32) {
        return 0x696d206173204743202c207369676e20746869732061677265656d656e740000;
    }
}

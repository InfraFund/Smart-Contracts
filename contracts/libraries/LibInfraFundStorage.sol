    // SPDX-License-Identifier: MIT
    pragma solidity 0.8.19;


    library LibInfraFundStorage {

        bytes32 constant STORAGE_POSITION = keccak256("infrafund.storage");
        
        struct CharityProject{
            string name;
            string symbol;
            address proposer;
            address contractAddress;
            address gc;
            uint256 startTime;
            uint256 investmentPeriod;
            uint256 targetAmount;
            Stages[] stages;
            bool isVerified;
            bool exist;
        }
        struct LoanProject{
            string name;
            string symbol;
            address proposer;
            address contractAddress;
            address gc;
            uint256 startTime;
            uint256 investmentPeriod;
            uint256 targetAmount;
            Stages[] stages;
            bool isVerified;
            bool exist;
        }
        struct PresaleProject{
            string name;
            string symbol;
            address proposer;
            address contractAddress;
            address gc;
            uint256 startTime;
            uint256 investmentPeriod;
            uint256 targetAmount;
            Stages[] stages;
            bool isVerified;
            bool exist;
        }
        struct SecurityTokenProject{
            string name;
            string symbol;
            address proposer;
            address contractAddress;
            address gc;
            uint256 startTime;
            uint256 investmentPeriod;
            uint256 targetAmount;
            Stages[] stages;
            bool isVerified;
            bool exist;
        }

        struct Stages {
            uint256 neededFund;
            uint256 proposedTime;
        }

        struct GCStages {
            uint256 neededFund;
            uint256 proposedTime;
            uint256 neededExteraFund;
            bool isClaimed;
            bool isVerfied;
            bool isClaimedExteraFund;
            bool isVerfiedExteraFund;
        }
        
        uint CHARITY = 1;
        uint LOAN = 2;
        uint PRESALE = 3;
        uint SECURITY_TOKEN = 4;


        event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

        function setContractOwner(address _newOwner) internal {
            InfraFundStorage storage ds = infraFundStorage();
            address previousOwner = ds.contractOwner;
            ds.contractOwner = _newOwner;
            emit OwnershipTransferred(previousOwner, _newOwner);
        }

        function contractOwner() internal view returns (address contractOwner_) {
            contractOwner_ = infraFundStorage().contractOwner;
        }

        function enforceIsContractOwner() internal view {
            require(msg.sender == infraFundStorage().contractOwner, "LibDiamond: Must be contract owner");
        }


        function isAuditor(address _auditor) internal view returns(bool) {
            return infraFundStorage().auditors[_auditor]; 
        }

        function isInvestor(address _investor) internal view returns(bool) {
            return infraFundStorage().investors[_investor]; 
        }
        
        function isGC(address _GC) internal view returns(bool) {
            return infraFundStorage().generalConstructors[_GC]; 
        }

        function isVerifiedClient(address _client) internal view returns(bool) {
            return infraFundStorage().verifiedClients[_client]; 
        }


        struct InfraFundStorage {

            string[] proposals;
            uint256 proposalFee;
            uint256 totalInvestment;

            mapping(address => bool) verifiedClients;
            mapping(address => bool) auditors;
            mapping(address => bool) investors;
            mapping(address => bool) generalConstructors;

            mapping(string => uint256) projectBalance;
            mapping(string => mapping(address => uint256)) amountOfInvestment;
            mapping(address => string[]) listProjectsPerAddress;
    
            mapping(string => uint8) projectType;
            mapping(string => CharityProject) charityProjects;
            mapping(string => LoanProject) loanProjects;
            mapping(string => PresaleProject) presaleProjects;
            mapping(string => SecurityTokenProject) securityProjects;
            
            address contractOwner;
            address tokenPayment;
        }


        function infraFundStorage() internal pure returns (InfraFundStorage storage st) {
            bytes32 position = STORAGE_POSITION;
            assembly {
                st.slot := position
            }
        }
    }

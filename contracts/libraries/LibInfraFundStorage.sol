    // SPDX-License-Identifier: MIT
    pragma solidity 0.8.20;


    library LibInfraFundStorage {

        bytes32 constant STORAGE_POSITION = keccak256("infrafund.storage");
        
        struct CharityProject{
            string name;
            string symbol;
            address proposer;
            address gc;
            address contractAddress;
            address nftAddress;
            string nftURI;
            uint256 endOfInvestmentPeriodTime;
            uint256 targetAmountOfCapital;
            GCStages[] stages;
            bool isVerified;
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
            GCStages[] stages;
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
            GCStages[] stages;
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
            GCStages[] stages;
            bool isVerified;
            bool exist;
        }
        struct GCStages {
            uint256 neededFund;
            uint256 proposedFinishTime;
            uint256 KPI;
        }
        struct AddressStruct {
            address userFacetAddress;
            address proposer;
            address nftAddress;
            address gc;
            address tokenPayment;
        }        
        struct StringStruct {
            string hashProposal;
            string symbol;
            string nftURI;
            string name;
        }

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


        modifier AuditorOnly(address _auditor) {
            require(LibInfraFundStorage.isAuditor(_auditor), "Your Not Auditor");
            _;
        }

        modifier InvestorOnly(address _investor) {
            require(LibInfraFundStorage.isInvestor(_investor), "Your Not Investor");
            _;
        }

        modifier GCOnly(address _gc) {
            require(LibInfraFundStorage.isGC(_gc), "Your Not GC");
            _;
        }
        
        modifier ClientOnly(address _client) {
            require(LibInfraFundStorage.isVerifiedClient(_client), "Your Not Client");
            _;
        }


        struct InfraFundStorage {

            uint8 CHARITY;
            uint8 LOAN;
            uint8 PRESALE;
            uint8 SECURITY_TOKEN;

            string[] proposals;
            uint256 proposalFee;
            uint256 totalInvestment;

            mapping(address => bool) verifiedClients;
            mapping(address => bool) auditors;
            mapping(address => bool) investors;
            mapping(address => bool) generalConstructors;

            mapping(string => uint256) projectBalance;
            mapping(string => mapping(address => uint256)) amountOfInvestment;
            // mapping(address => string[]) listProjectsPerAddress;
    
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

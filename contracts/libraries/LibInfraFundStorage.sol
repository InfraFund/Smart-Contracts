    // SPDX-License-Identifier: MIT
    pragma solidity 0.8.19;


    library LibInfraFundStorage {
        bytes32 constant STORAGE_POSITION = keccak256("infrafund.storage");
        
        struct CharityProject{
            string name;
            string symbol;
            address proposer;
            address contractAddress;
            address GC;
            uint startTime;
            uint duration;
            uint targetAmount;
            bool isVerified;
        }

        struct GCProposal{
            uint256 neededFund;
            uint64 proposedTime;
            uint64 votingDuration;
            uint128 voteCount;
            bool isVerified;
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



        struct InfraFundStorage {

            string[] proposals;
            uint256 proposalFee;

            mapping(address => bool) verifiedClients;
            mapping(address => bool) auditors;
            mapping(address => bool) investors;
            mapping(address => bool) generalConstructors;

            mapping(string => CharityProject) charityProjects;
            mapping(string =>  GCProposal) gcProposals;
            
            address contractOwner;

        }
 

        function infraFundStorage() internal pure returns (InfraFundStorage storage st) {
            bytes32 position = STORAGE_POSITION;
            assembly {
                st.slot := position
            }
        }
    }

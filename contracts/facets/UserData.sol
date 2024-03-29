// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";

contract UserData {

    function getAddress() external view returns(address) {
        return address(this);
    }

    function isInvestor(address _investor) external view returns(bool) {
        return LibInfraFundStorage.isInvestor(_investor);
    }
    function isClient(address _client) external view returns(bool) {
        return LibInfraFundStorage.isVerifiedClient(_client);
    }
    function isAuditor(address _auditor) external view returns(bool) {
        return LibInfraFundStorage.isAuditor(_auditor);
    }
    function isGC(address _GC) external view returns(bool) {
        return LibInfraFundStorage.isGC(_GC);
    }

}
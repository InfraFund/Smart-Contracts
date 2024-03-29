// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { LibInfraFundStorage } from "../libraries/LibInfraFundStorage.sol";

contract UserData {

    function userDataConst() external returns(address) {
        return address(this);
    }

    function isInvestor(address _investor) external returns(bool) {
        return LibInfraFundStorage.isInvestor(_investor);
    }
    function isClient(address _client) external returns(bool) {
        return LibInfraFundStorage.isVerifiedClient(_client);
    }
    function isAuditor(address _auditor) external returns(bool) {
        return LibInfraFundStorage.isAuditor(_auditor);
    }
    function isGC(address _GC) external returns(bool) {
        return LibInfraFundStorage.isGC(_GC);
    }

}
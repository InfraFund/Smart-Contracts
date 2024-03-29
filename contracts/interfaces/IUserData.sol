// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IUserData {

    function userDataConst() external returns(address);

    function isInvestor(address _investor) external returns(bool);

    function isClient(address _client) external returns(bool);

    function isAuditor(address _auditor) external returns(bool);

    function isGC(address _GC) external returns(bool);

}
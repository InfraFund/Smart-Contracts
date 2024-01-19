// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPermissionManagement { 

    function registerAuditor(address _newAuditor) external;
    function revokeAuditor(address _auditor) external;

    function registerInvestor(address _newInvestor) external;
    function revokeInvestor(address _investor) external;

    function registerGC(address _newGC) external;
    function revokeGC(address _GC) external;

    function registerClient(address _newClient) external;
    function revokeClient(address _client) external;
}

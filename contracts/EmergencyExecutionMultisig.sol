// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {RestrictedMultisigBase} from "./RestrictedMultisigBase.sol";

interface IEmergencyProtectedTimelock {
    function emergencyExecute(uint256 proposalId) external;
    function emergencyReset() external;
}

contract EmergencyExecutionMultisig is RestrictedMultisigBase {
    address public immutable EMERGENCY_PROTECTED_TIMELOCK;

    constructor(
        address OWNER,
        address[] memory multisigMembers,
        uint256 executionQuorum,
        address emergencyProtectedTimelock
    ) RestrictedMultisigBase(OWNER, multisigMembers, executionQuorum) {
        EMERGENCY_PROTECTED_TIMELOCK = emergencyProtectedTimelock;
    }

    // Emergency Execution

    function voteEmergencyExecute(uint256 _proposalId, bool _supports) public onlyMember {
        _vote(_buildEmergencyExecuteAction(_proposalId), _supports);
    }

    function getEmergencyExecuteState(uint256 _proposalId)
        public
        view
        returns (uint256 support, uint256 execuitionQuorum, bool isExecuted)
    {
        return getActionState(_buildEmergencyExecuteAction(_proposalId));
    }

    function executeEmergencyExecute(uint256 _proposalId) public {
        _execute(_buildEmergencyExecuteAction(_proposalId));
    }

    // Governance reset

    function approveEmergencyReset() public onlyMember {
        _vote(_buildEmergencyResetAction(), true);
    }

    function getEmergencyResetState()
        public
        view
        returns (uint256 support, uint256 execuitionQuorum, bool isExecuted)
    {
        return getActionState(_buildEmergencyResetAction());
    }

    function executeEmergencyReset() external {
        _execute(_buildEmergencyResetAction());
    }

    function _buildEmergencyResetAction() internal view returns (Action memory) {
        return Action(EMERGENCY_PROTECTED_TIMELOCK, abi.encodeWithSignature("emergencyReset()"));
    }

    function _buildEmergencyExecuteAction(uint256 proposalId) internal view returns (Action memory) {
        return Action(EMERGENCY_PROTECTED_TIMELOCK, abi.encodeWithSignature("emergencyExecute(uint256)", proposalId));
    }
}

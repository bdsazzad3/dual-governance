// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {RestrictedMultisigBase} from "./RestrictedMultisigBase.sol";

contract TiebreakerCore is RestrictedMultisigBase {
    address immutable DUAL_GOVERNANCE;

    constructor(
        address owner,
        address[] memory multisigMembers,
        uint256 executionQuorum,
        address dualGovernance
    ) RestrictedMultisigBase(owner, multisigMembers, executionQuorum) {
        DUAL_GOVERNANCE = dualGovernance;
    }

    function approveProposal(uint256 _proposalId) public onlyMember {
        _vote(_buildApproveProposalAction(_proposalId), true);
    }

    function getApproveProposalState(uint256 _proposalId)
        public
        view
        returns (uint256 support, uint256 execuitionQuorum, bool isExecuted)
    {
        return getActionState(_buildApproveProposalAction(_proposalId));
    }

    function executeApproveProposal(uint256 _proposalId) public {
        _execute(_buildApproveProposalAction(_proposalId));
    }

    function _buildApproveProposalAction(uint256 _proposalId) internal view returns (Action memory) {
        return Action(DUAL_GOVERNANCE, abi.encodeWithSignature("tiebreakerApproveProposal(uint256)", _proposalId));
    }
}

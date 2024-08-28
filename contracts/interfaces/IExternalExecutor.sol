// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IExternalExecutor {
    function execute(
        address target,
        uint256 value,
        bytes calldata payload
    ) external payable returns (bytes memory result);
}
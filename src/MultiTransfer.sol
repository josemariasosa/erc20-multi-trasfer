// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { ReentrancyGuard } from "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

struct Transfer {
    address receiver_id;
    uint256 amount;
}

contract MultiTransfer is ReentrancyGuard {

    /// From a best practices standpoint, especially in financial transactions,
    /// ensuring that all prerequisites are met before performing any state-changing
    /// actions (like transferring Ether) is often considered safer and more reliable.

    function multiNativeTransfer(
        Transfer[] calldata _transfers
    ) external payable nonReentrant {
        require(msg.value > 0, "No Ether sent");

        uint256 accumAmount;
        uint256 len = _transfers.length;
        for (uint i = 0; i < len; ++i) {
            accumAmount += _transfers[i].amount;
        }
        require(msg.value >= accumAmount, "Insufficient amount");

        for (uint i = 0; i < len; ++i) {
            require(payable(_transfers[i].receiver_id).send(_transfers[i].amount), "Failed to send Ether");
        }

        // Returning the change 🪙
        if (accumAmount < msg.value) {
            require(payable(msg.sender).send(msg.value - accumAmount), "Transfer failed");
        }
    }

    function multiTransfer(
        IERC20 _token,
        uint256 _amount,
        Transfer[] calldata _transfers
    ) external nonReentrant {
        require(_amount > 0, "No Amount sent");
        _token.transferFrom(msg.sender, address(this), _amount);

        uint256 accumAmount;
        uint256 len = _transfers.length;
        for (uint i = 0; i < len; ++i) {
            accumAmount += _transfers[i].amount;
        }
        require(_amount >= accumAmount, "Insufficient amount");

        for (uint i = 0; i < len; ++i) {
            require(_token.transfer(_transfers[i].receiver_id, _transfers[i].amount), "Transfer failed");
        }

        // Returning the change 🪙
        if (accumAmount < _amount) {
            require(_token.transfer(msg.sender, _amount - accumAmount), "Transfer failed");
        }
    }
}

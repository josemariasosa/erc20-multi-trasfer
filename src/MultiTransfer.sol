// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { ReentrancyGuard } from "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

struct Transfer {
    address receiver_id;
    uint256 amount;
}

contract MultiTransfer is ReentrancyGuard {

    function multiTransfer(
        IERC20 _token,
        uint256 _amount,
        Transfer[] calldata _transfers
    ) external nonReentrant {
        _token.transferFrom(msg.sender, address(this), _amount);

        uint256 _txAmount;
        uint256 accumAmount;
        uint256 len = _transfers.length;
        for (uint i = 0; i < len; ++i) {
            _txAmount = _transfers[i].amount;
            accumAmount += _txAmount;
            require(_token.transfer(_transfers[i].receiver_id, _txAmount), "Transfer failed");
        }
        require(_amount >= accumAmount, "Insufficient amount");

        // Returning the change 🪙
        if (accumAmount < _amount) {
            require(_token.transfer(msg.sender, _amount - accumAmount), "Transfer failed");
        }
    }
}

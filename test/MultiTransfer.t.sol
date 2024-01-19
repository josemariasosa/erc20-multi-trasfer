// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../src/MultiTransfer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { Token } from "../src/mock/Token.sol";


contract MultiTransferTest is Test {

    address public owner = address(1);
    address public test1 = address(2);
    address public test2 = address(3);

    MultiTransfer public multiTransfer;
    Token public token;

    function setUp() public {
        multiTransfer = new MultiTransfer();
        token = new Token(owner);
    }

    function _split(
        uint256 _amount
    ) private pure returns (uint256 amount1, uint256 amount2) {
        amount1 = (_amount / 2) + 1;
        amount2 = _amount - amount1;
    }

    function testPerfectMultiTransfer(uint256 _amount) public {
        // Ensure _amount is within valid range
        vm.assume(_amount > 4 && _amount < token.totalSupply());

        (uint256 amount1, uint256 amount2) = _split(_amount);
        Transfer[] memory transfers = new Transfer[](2);
        transfers[0] = Transfer(test1, amount1);
        transfers[1] = Transfer(test2, amount2);

        // Assert
        assertEq(token.balanceOf(test1), 0);
        assertEq(token.balanceOf(test2), 0);

        vm.startPrank(owner);
        token.approve(address(multiTransfer), _amount);
        multiTransfer.multiTransfer(IERC20(address(token)), transfers);
        vm.stopPrank();

        // Assert
        assertEq(token.balanceOf(test1), amount1);
        assertEq(token.balanceOf(test2), amount2);
    }

    function testTransferAndReturnChange(uint256 _amount) public {
        // Ensure _amount is greater than 4
        vm.assume(_amount > 4 && _amount < token.totalSupply());

        (uint256 amount1, uint256 amount2) = _split(_amount);
        Transfer[] memory transfers = new Transfer[](2);
        transfers[0] = Transfer(test1, amount1 - 1);
        transfers[1] = Transfer(test2, amount2 - 1);

        // uint __amount_to_transfer;
        // for (uint i = 0; i < transfers.length; i++) {
        //     console.log("Transfer to:", transfers[i].receiver_id);
        //     console.log("Amount:", transfers[i].amount);
        //     __amount_to_transfer += transfers[i].amount;
        // }

        vm.startPrank(owner);
        token.approve(address(multiTransfer), _amount);
        uint256 currentBalance = token.balanceOf(owner);
        multiTransfer.multiTransfer(IERC20(address(token)), transfers);
        // owner balance after sending 2 more and getting it back as change.
        assertEq(currentBalance - _amount + 2, token.balanceOf(owner));
        vm.stopPrank();
    }

    function testFailMultiTransferWithInsufficientAllowance(uint256 _amount) public {
        // Skip test cases where _amount is zero or too large
        vm.assume(_amount > 4 && _amount < token.totalSupply());

        // Create a scenario where the sum of transfers is greater than _amount
        (uint256 amount1, uint256 amount2) = _split(_amount);
        uint256 lessTotalAmount = amount1 + amount2 - 1;
        Transfer[] memory transfers = new Transfer[](2);
        transfers[0] = Transfer(address(1), amount1);
        transfers[1] = Transfer(address(2), amount2);

        vm.startPrank(owner);
        token.approve(address(multiTransfer), lessTotalAmount);
        multiTransfer.multiTransfer(IERC20(address(token)), transfers);
        vm.stopPrank();
    }

    function testFailMultiTransferWithInsufficientBalance(uint256 _amount) public {
        // Skip test cases where _amount is zero or too large
        vm.assume(_amount > 4 && _amount < token.totalSupply());

        // Create a scenario where the sum of transfers is greater than _amount
        (uint256 amount1, uint256 amount2) = _split(_amount);

        Transfer[] memory transfers = new Transfer[](2);
        transfers[0] = Transfer(address(1), amount1);
        transfers[1] = Transfer(address(2), amount2 + 1);

        vm.startPrank(owner);
        token.approve(address(multiTransfer), _amount);
        multiTransfer.multiTransfer(IERC20(address(token)), transfers);
        vm.stopPrank();
    }
}

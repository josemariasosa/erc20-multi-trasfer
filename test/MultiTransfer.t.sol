// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MultiTransfer.sol";
import { Token } from "../src/mock/Token.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import "forge-std/console.sol";


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
        vm.assume(_amount > 2 && _amount < token.totalSupply());

        (uint256 amount1, uint256 amount2) = _split(_amount);
        
        Transfer[] memory transfers = new Transfer[](2);
        transfers[0] = Transfer(test1, amount1);
        transfers[1] = Transfer(test2, amount2);

        // Assert
        assertEq(token.balanceOf(test1), 0);
        assertEq(token.balanceOf(test2), 0);

        vm.startPrank(owner);
        token.approve(address(multiTransfer), _amount);
        multiTransfer.multiTransfer(IERC20(address(token)), _amount, transfers);
        vm.stopPrank();

        // Assert
        assertEq(token.balanceOf(test1), amount1);
        assertEq(token.balanceOf(test2), amount2);
    }

    function testFailMultiTransferWithInsufficientAllowance(uint256 _amount) public {
        // Skip test cases where _amount is zero or too large
        vm.assume(_amount > 0 && _amount < token.totalSupply());

        // Create a scenario where the sum of transfers is greater than _amount
        (uint256 amount1, uint256 amount2) = _split(_amount);
        uint256 totalAmount = amount1 + amount2 - 1;

        Transfer[] memory transfers = new Transfer[](2);
        transfers[0] = Transfer(address(1), amount1);
        transfers[1] = Transfer(address(2), amount2);

        vm.startPrank(owner);
        token.approve(address(multiTransfer), totalAmount);
        multiTransfer.multiTransfer(IERC20(address(token)), _amount, transfers);
        vm.stopPrank();
    }

    function testFailMultiTransferWithInsufficientBalance(uint256 _amount) public {
        // Skip test cases where _amount is zero or too large
        vm.assume(_amount > 0 && _amount < token.totalSupply());

        // Create a scenario where the sum of transfers is greater than _amount
        (uint256 amount1, uint256 amount2) = _split(_amount);

        Transfer[] memory transfers = new Transfer[](2);
        transfers[0] = Transfer(address(1), amount1);
        transfers[1] = Transfer(address(2), amount2 + 1);

        vm.startPrank(owner);
        token.approve(address(multiTransfer), _amount);
        multiTransfer.multiTransfer(IERC20(address(token)), _amount, transfers);
        vm.stopPrank();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(address _owner) ERC20("Test Token", "TT") {
        uint256 supply = 1000 * 1E18;
        _mint(_owner, supply);
    }
}
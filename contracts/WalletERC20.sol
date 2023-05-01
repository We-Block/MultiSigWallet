// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./WalletOwners.sol";

library WalletERC20 {
    using WalletOwners for WalletOwners.Owners;

    event TokenWithdrawal(address indexed receiver, address indexed token, uint256 value);

    function withdraw(WalletOwners.Owners storage owners, IERC20 token, address to, uint256 amount, address sender) internal {
        require(owners.isOwner[sender], "WalletERC20: caller is not an owner");
        require(token.balanceOf(address(this)) >= amount, "WalletERC20: insufficient token balance");
        token.transfer(to, amount);
        emit TokenWithdrawal(to, address(token), amount);
    }
}

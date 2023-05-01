// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WalletOwners.sol";

library WalletETH {
    using WalletOwners for WalletOwners.Owners;

    event Deposit(address indexed sender, uint256 value);
    event Withdrawal(address indexed receiver, uint256 value);

    function deposit(address sender, uint256 value) internal {
        emit Deposit(sender, value);
    }

    function withdrawETH(WalletOwners.Owners storage owners, address payable to, uint256 amount, address sender) internal {
        require(owners.isOwner[sender], "WalletETH: caller is not an owner");
        require(address(this).balance >= amount, "WalletETH: insufficient balance");
        to.transfer(amount);
        emit Withdrawal(to, amount);
    }
}

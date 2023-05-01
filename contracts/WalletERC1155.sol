// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "./WalletOwners.sol";

library WalletERC1155 {
    using WalletOwners for WalletOwners.Owners;

    function withdraw(WalletOwners.Owners storage owners, IERC1155 token, address to, uint256 tokenId, uint256 amount, bytes memory data, address sender) internal {
        require(owners.isOwner[sender], "WalletERC1155: caller is not an owner");
        token.safeTransferFrom(address(this), to, tokenId, amount, data);
    }
}

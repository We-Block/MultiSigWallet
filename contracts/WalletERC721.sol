// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./WalletOwners.sol";

library WalletERC721 {
    using WalletOwners for WalletOwners.Owners;

    function withdraw(WalletOwners.Owners storage owners, IERC721 token, address to, uint256 tokenId, address sender) internal {
        require(owners.isOwner[sender], "WalletERC721: caller is not an owner");
        token.safeTransferFrom(address(this), to, tokenId);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library WalletOwners {
    struct Owners {
        uint256 count;
        mapping(address => bool) isOwner;
        mapping(address => uint256) index;
        address[] ownerList;
    }

    function init(Owners storage self, address[] memory _owners) internal {
        require(_owners.length > 0, "WalletOwners: Owners list cannot be empty");
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "WalletOwners: Owner address cannot be 0");
            require(!self.isOwner[owner], "WalletOwners: Duplicate owner in the list");
            self.isOwner[owner] = true;
            self.index[owner] = i;
            self.ownerList.push(owner);
        }
        self.count = _owners.length;
    }

    function getOwnersSize(Owners storage self) internal view returns (uint256) {
        return self.ownerList.length;
    }
}

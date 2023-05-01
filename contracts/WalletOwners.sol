// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library WalletOwners {
    struct Owners {
        uint256 count;
        mapping(address => bool) isOwner;
        mapping(address => uint256) index;
        address[] ownerAddresses;
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

    function addOwner(Owners storage self, address newOwner) internal {
        require(newOwner != address(0), "WalletOwners: new owner is the zero address");
        require(!self.isOwner[newOwner], "WalletOwners: new owner already exists");

        self.ownerAddresses.push(newOwner);
        self.isOwner[newOwner] = true;
    }


    function removeOwner(Owners storage self, address ownerToRemove) internal {
        require(self.isOwner[ownerToRemove], "WalletOwners: owner does not exist");
        require(self.ownerAddresses.length > 1, "WalletOwners: cannot remove the last owner");

        for (uint256 i = 0; i < self.ownerAddresses.length; i++) {
            if (self.ownerAddresses[i] == ownerToRemove) {
                self.ownerAddresses[i] = self.ownerAddresses[self.ownerAddresses.length - 1];
                self.ownerAddresses.pop();
                break;
            }
        }

        delete self.isOwner[ownerToRemove];
    }


}

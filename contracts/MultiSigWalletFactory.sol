// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ConcreteMultiSigWallet.sol";

contract MultiSigWalletFactory {
    event MultiSigWalletCreated(address indexed walletAddress, address[] owners);

    function createMultiSigWallet(address[] memory _owners) public returns (address) {
        ConcreteMultiSigWallet wallet = new ConcreteMultiSigWallet(_owners);
        emit MultiSigWalletCreated(address(wallet), _owners);
        return address(wallet);
    }
}

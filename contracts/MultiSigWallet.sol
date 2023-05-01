// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WalletOwners.sol";
import "./WalletETH.sol";
import "./WalletERC20.sol";
import "./WalletERC721.sol";
import "./WalletERC1155.sol";
import "./TokenReceiver.sol";
import "./TransactionProposal.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract MultiSigWallet is IERC721Receiver, IERC1155Receiver, Ownable {
    using WalletOwners for WalletOwners.Owners;
    using WalletETH for address;
    using WalletERC20 for WalletOwners.Owners;
    using WalletERC721 for WalletOwners.Owners;
    using WalletERC1155 for WalletOwners.Owners;
    using TransactionProposal for TransactionProposal.Proposals;

    WalletOwners.Owners internal owners;
    TransactionProposal.Proposals internal proposals;

    constructor(address[] memory _owners) {
        owners.init(_owners);
    }

    receive() external payable {
        WalletETH.deposit(msg.sender, msg.value);
    }

    function createProposal(address payable to, uint256 value) public returns (uint256) {
        return proposals.create(owners, to, value, msg.sender);
    }

    function voteProposal(uint256 proposalId, bool approve) public {
        proposals.vote(owners, proposalId, approve, msg.sender);
    }

    function executeProposal(uint256 proposalId) public {
        proposals.execute(proposalId);
    }


    function withdrawERC20(IERC20 token, address to, uint256 amount) public {
        owners.withdraw(token, to, amount, msg.sender);
    }

    function withdrawERC721(IERC721 token, address to, uint256 tokenId) public {
        owners.withdraw(token, to, tokenId, msg.sender);
    }

    function withdrawERC1155(IERC1155 token, address to, uint256 tokenId, uint256 amount, bytes memory data) public {
        owners.withdraw(token, to, tokenId, amount, data, msg.sender);
    }
    function getProposal(uint256 proposalId)
    public
    view
    returns (
        address creator,
        address to,
        uint256 value,
        uint256 approvals,
        uint256 disapprovals,
        TransactionProposal.ProposalStatus status
    )
{
    return proposals.getProposal(proposalId,owners);
}

}

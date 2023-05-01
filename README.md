# MultiSig Wallet

## Introduction

This MultiSig Wallet is a smart contract that enables multiple owners (signatories) to jointly manage the wallet's assets, which include Ether (ETH), ERC20 tokens, ERC721 tokens, and ERC1155 tokens. Assets in the wallet can only be transferred when a majority of the owners approve the transaction. This provides an added layer of security and control compared to traditional single-owner wallets.

## Features

- Manage multiple types of assets: ETH, ERC20, ERC721, and ERC1155 tokens.
- Wallet actions (transfers) require a majority of owners' approval.
- Support for adding and removing wallet owners.
- Proposal system for initiating and approving transfers.
- Visibility into the status of each proposal and asset within the wallet.

## How it works

1. **Initialize Wallet Owners**: When deploying the wallet contract, the constructor receives an array of addresses as the initial wallet owners. These addresses are stored in the contract, and the contract ensures that only these addresses can initiate and approve transactions.
  
2. **Receive Assets**: The wallet can receive assets, such as ETH, ERC20, ERC721, and ERC1155 tokens, through the fallback function or by calling the corresponding token contract's transfer functions.
  
3. **Create Transfer Proposal**: To transfer assets from the wallet, one of the wallet's owners must create a proposal, specifying the recipient address, the asset type, and the amount to be transferred.
  
4. **Approve or Reject Proposal**: Other wallet owners can review the transfer proposal and either approve or reject it by calling the `vote` function. Each owner can only vote once per proposal.
  
5. **Execute Transfer**: Once a majority of the wallet's owners have approved the proposal, the transaction can be executed by calling the `executeProposal` function. This will transfer the specified assets to the recipient address.
  
6. **Query Proposal Information**: Users can query proposal details, including the creator, recipient, value, number of approvals, number of disapprovals, and the proposal status.
  
7. **Add and Remove Owners**: The contract also supports adding and removing wallet owners, ensuring that the control over the wallet can be modified as necessary.
  

## Getting Started

To use this MultiSig Wallet, follow these steps:

1. Deploy the `MultiSigWallet` contract, providing an array of initial owner addresses.
2. To add or remove owners, call the `addOwner` or `removeOwner` functions, respectively.
3. To create a transfer proposal, call the `createProposal` function with the necessary parameters.
4. To vote on a proposal, call the `vote` function with the proposal ID and your decision (approve or reject).
5. Once a majority of owners have approved a proposal, execute the transfer by calling the `executeProposal` function.

## Security Considerations

This MultiSig Wallet provides an additional layer of security compared to traditional single-owner wallets. However, it is essential to ensure that the wallet's private keys are securely managed and that the smart contract code is thoroughly audited to prevent potential vulnerabilities or exploits.
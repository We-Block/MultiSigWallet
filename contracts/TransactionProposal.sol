// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WalletOwners.sol";

library TransactionProposal {
    enum ProposalStatus {Pending, Approved, Executed, Rejected}
    enum VoteStatus { NotVoted, Voted }


    struct Proposal {
        uint256 id;
        address creator;
        address payable to;
        uint256 value;
        uint256 approvals;
        uint256 rejections;
        mapping(address => bool) approved;
        mapping(address => VoteStatus) votes;
        ProposalStatus status;
    }




    struct Proposals {
        uint256 nextProposalId;
        mapping(uint256 => Proposal) proposals;
        mapping(uint256 => mapping(address => bool)) voted;
    }

    function create(
        Proposals storage self,
        WalletOwners.Owners storage owners,
        address payable to,
        uint256 value,
        address creator
    ) internal returns (uint256) {
        require(owners.isOwner[creator], "TransactionProposal: Only wallet owners can create proposals");
        uint256 proposalId = self.nextProposalId;
        self.nextProposalId++;

        Proposal storage proposal = self.proposals[proposalId];
        proposal.id = proposalId;
        proposal.status = ProposalStatus.Pending;
        proposal.creator = creator;
        proposal.to = to;
        proposal.value = value;

        return proposalId;
    }

    function vote(
        Proposals storage self,
        WalletOwners.Owners storage owners,
        uint256 proposalId,
        bool approve,
        address voter
    ) internal {
        require(owners.isOwner[voter], "TransactionProposal: Only wallet owners can vote");
        Proposal storage proposal = self.proposals[proposalId];
        require(proposal.status == ProposalStatus.Pending, "TransactionProposal: Proposal is not pending");
        require(!self.voted[proposalId][voter], "TransactionProposal: Owner has already voted");

        if (approve) {
            proposal.approvals++;
        } else {
            proposal.rejections++;
        }

        self.voted[proposalId][voter] = true;
        uint256 totalVotes = proposal.approvals + proposal.rejections;
        uint256 requiredVotes = (WalletOwners.getOwnersSize(owners) / 2) + 1;


        if (totalVotes >= requiredVotes) {
            if (proposal.approvals > proposal.rejections) {
                proposal.status = ProposalStatus.Approved;
            } else {
                proposal.status = ProposalStatus.Rejected;
            }
        }
    }

    function execute(Proposals storage self, uint256 proposalId) internal {
        Proposal storage proposal = self.proposals[proposalId];
        require(proposal.status == ProposalStatus.Approved, "TransactionProposal: Proposal is not approved");
        proposal.status = ProposalStatus.Executed;
        proposal.to.transfer(proposal.value);
    }
    
    function getDisapprovals(Proposal storage proposal, WalletOwners.Owners storage owners) private view returns (uint256) {
        uint256 disapprovals = 0;
        for (uint256 i = 0; i < owners.ownerList.length; i++) {
            address owner = owners.ownerList[i];
            if (proposal.votes[owner] == VoteStatus.Voted && !proposal.approved[owner]) {
                disapprovals++;
            }
        }
        return disapprovals;
    }


    

    function getProposal(Proposals storage self, uint256 proposalId, WalletOwners.Owners storage owners) internal view returns (
        address creator,
        address to,
        uint256 value,
        uint256 approvals,
        uint256 disapprovals,
        ProposalStatus status
    )
    {
        Proposal storage proposal = self.proposals[proposalId];
        creator = proposal.creator;
        to = proposal.to;
        value = proposal.value;
        approvals = proposal.approvals;
        disapprovals = getDisapprovals(proposal, owners);
        status = proposal.status;
    }




}

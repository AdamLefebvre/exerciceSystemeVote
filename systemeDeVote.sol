// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Voting is Ownable {
    uint256 winningProposalId;

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    } //Le(s) voteur(s)

    struct Proposal {
        string description;
        uint256 voteCount;
    } //Le(s) Proposal

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    mapping(address => bool) whitelist;
    mapping(address => uint256) proposals;
    mapping(address => uint256) votes;

    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(
        WorkflowStatus previousStatus,
        WorkflowStatus newStatus
    );
    event ProposalRegistered(uint256 proposalId);
    event Voted(address voter, uint256 proposalId);

    modifier registred() {
        require(
            whitelist[msg.sender] == true,
            "Vous n'avez pas acces a la whitelist"
        );
        _;
    }

    function _registerVoter(address _voterAddress, bool _isRegistered)
        public
        view
        onlyOwner
    {
        require(
            !whitelist[_voterAddress],
            "Cet utilisateur ne peut plus etre enregistre"
        );
        whitelist[_voterAddress] = true;
        emit VoterRegistered(_voterAddress);
    }

    function getVoter(address _voterAddress) public view returns (bool) {
        return whitelist[_voterAddress];
    }

    function startRegistration() public view {
        WorkflowStatus registrationStarting;
        registrationStarting = WorkflowStatus.ProposalsRegistrationStarted;
    }

    function votersProposals(string _description, uint256 _voteCount)
        public
        returns (string, uint256)
    {
        require(
            registrationStarting == true,
            "L'enregistrement des propositions n'a pas commence"
        );
        Proposal memory voterProposal;
        voterProposal("_description", _voteCount++);
        return voterProposal;
        emit ProposalRegistered(_proposalId);
    }

    function endRegistration() public view {
        WorkflowStatus registrationEnding = ProposalsRegistrationEnded;
    }

    function startVote() public view {
        WorkflowStatus voteStarting = VotingSessionStarted;
    }

    function votersVote(uint256 _voterProposalId, uint256 _voteCount)
        public
        view
        returns (uint256)
    {
        require(
            VotingSessionStarted == true,
            "La session de vote n'a pas commence"
        );
        return vote = voterProposal[_votedProposalId].voteCount++;
        emit Voted(msg.sender, _voterProposal);
    }

    function endVote() public view {
        WorkflowStatus voteEnding = VotingSessionEnded;
    }

    function calculateVotes(uint256 _votedProposalId, uint256 _voteCount)
        public
        onlyOwner
        returns (uint256)
    {
        if (votedProposalId.voteCount > vote.voteCount) {
            winningProposalId = _votedProposalId;
        } else {
            require(
                _votedProposalId.voteCount > vote.Count,
                "Il n'y a pas de gagnant"
            );
        }
        return winningProposalId;
    }
}

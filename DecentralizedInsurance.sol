// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Decentralized Insurance Smart Contract
// Allows insurer to issue policies, policyholders to pay premiums and submit claims,
// and insurer to approve/reject/pay claims with full transparency on Ethereum.

contract DecentralizedInsurance {

    // Contract owner (insurer)
    address public insurer;

    // Policy and claim counters
    uint public policyCounter;
    uint public claimCounter;

    // Stats tracking
    uint public totalIssued;
    uint public totalActive;
    uint public totalCancelled;

    // Address tracking for reporting
    address[] public issuedAddresses;
    address[] public activeAddresses;
    address[] public cancelledAddresses;

    // Flags to prevent duplicate counts
    mapping(address => bool) public isIssued;
    mapping(address => bool) public isActive;
    mapping(address => bool) public isCancelled;

    // Only insurer can call functions with this modifier
    modifier onlyInsurer() {
        require(msg.sender == insurer, "Only insurer allowed");
        _;
    }

    // Policy status values
    enum PolicyStatus { Inactive, Active, Expired, Lapsed, Cancelled }

    // Claim status values
    enum ClaimStatus { None, Pending, Approved, Rejected, Paid }

    // Insurance policy structure
    struct Policy {
        uint policyId;
        address policyholder;
        uint premium;             // premium amount (wei)
        uint coverageAmount;      // coverage limit (wei)
        uint startTime;           // policy start timestamp
        uint duration;            // policy duration in seconds
        bool isPaid;              // whether premium is paid
        PolicyStatus status;      // current status of policy
    }

    // Claim structure
    struct Claim {
        uint claimId;
        uint policyId;
        address claimant;
        uint claimAmount;         // claim amount requested (wei)
        string reason;            // claim reason (accident/fire/etc.)
        ClaimStatus status;       // current status of claim
    }

    // Mappings for storage
    mapping(uint => Policy) public policies;
    mapping(uint => Claim) public claims;
    mapping(address => uint[]) public userPolicies;
    mapping(uint => uint[]) public policyClaims;

    // Events for tracking on blockchain
    event PolicyIssued(uint policyId, address indexed policyholder, uint durationSeconds);
    event PremiumPaid(uint policyId, address indexed policyholder);
    event PolicyCancelled(uint policyId, address indexed policyholder);
    event PolicyLapsed(uint policyId);
    event ClaimSubmitted(uint claimId, uint policyId, address indexed claimant);
    event ClaimApproved(uint claimId, uint amount);
    event ClaimRejected(uint claimId, string reason);
    event ClaimPaid(uint claimId, address indexed claimant, uint amount);

    // Set insurer as deployer
    constructor() {
        insurer = msg.sender;
    }

    // Issue a new policy with duration in months and years
    // Input: _policyholder, _premium, _coverageAmount, _months, _years
    function issuePolicy(
        address _policyholder,
        uint _premium,
        uint _coverageAmount,
        uint _months,
        uint _years
    ) external onlyInsurer {
        policyCounter++;

        // Convert duration to seconds (1 month = 30 days)
        uint totalDuration = (_years * 12 + _months) * 30 days;

        policies[policyCounter] = Policy(
            policyCounter,
            _policyholder,
            _premium,
            _coverageAmount,
            0,
            totalDuration,
            false,
            PolicyStatus.Inactive
        );

        userPolicies[_policyholder].push(policyCounter);
        emit PolicyIssued(policyCounter, _policyholder, totalDuration);

        // Track issued user
        if (!isIssued[_policyholder]) {
            issuedAddresses.push(_policyholder);
            isIssued[_policyholder] = true;
            totalIssued++;
        }
    }

    // Pay premium for a policy and activate it
    // Input: _policyId (and send value = premium)
    function payPremium(uint _policyId) external payable {
        Policy storage policy = policies[_policyId];
        require(msg.sender == policy.policyholder, "Not your policy");
        require(policy.status == PolicyStatus.Inactive, "Policy not payable");
        require(msg.value == policy.premium, "Incorrect premium");

        policy.isPaid = true;
        policy.status = PolicyStatus.Active;
        policy.startTime = block.timestamp;

        emit PremiumPaid(_policyId, msg.sender);

        // Track active user
        if (!isActive[msg.sender]) {
            activeAddresses.push(msg.sender);
            isActive[msg.sender] = true;
            totalActive++;
        }
    }

    // Cancel a policy before paying premium
    // Input: _policyId
    function cancelPolicy(uint _policyId) external {
        Policy storage policy = policies[_policyId];
        require(msg.sender == policy.policyholder, "Not your policy");
        require(policy.status == PolicyStatus.Inactive, "Cannot cancel");

        policy.status = PolicyStatus.Cancelled;
        emit PolicyCancelled(_policyId, msg.sender);

        if (!isCancelled[msg.sender]) {
            cancelledAddresses.push(msg.sender);
            isCancelled[msg.sender] = true;
            totalCancelled++;
        }
    }

    // Lapse unpaid policy if grace period (7 days) has passed
    // Input: _policyId
    function lapseUnpaidPolicy(uint _policyId) external {
        Policy storage policy = policies[_policyId];
        require(policy.status == PolicyStatus.Inactive, "Not inactive");

        if (block.timestamp > policy.startTime + 7 days && !policy.isPaid) {
            policy.status = PolicyStatus.Lapsed;
            emit PolicyLapsed(_policyId);
        }
    }

    // Submit a claim against an active policy
    // Input: _policyId, _claimAmount (wei), _reason ("accident", etc.)
    function submitClaim(
        uint _policyId,
        uint _claimAmount,
        string memory _reason
    ) external {
        Policy storage policy = policies[_policyId];
        require(msg.sender == policy.policyholder, "Not your policy");
        require(policy.status == PolicyStatus.Active, "Policy not active");
        require(block.timestamp <= policy.startTime + policy.duration, "Policy expired");

        claimCounter++;
        claims[claimCounter] = Claim(
            claimCounter,
            _policyId,
            msg.sender,
            _claimAmount,
            _reason,
            ClaimStatus.Pending
        );

        policyClaims[_policyId].push(claimCounter);
        emit ClaimSubmitted(claimCounter, _policyId, msg.sender);
    }

    // Internal helper: max claim amount by reason
    function getMaxAllowed(string memory _reason) public pure returns (uint) {
        bytes32 hash = keccak256(abi.encodePacked(_reason));
        if (hash == keccak256("accident")) return 1000 ether;
        if (hash == keccak256("fire")) return 2000 ether;
        if (hash == keccak256("flood")) return 1500 ether;
        return 500 ether;
    }

    // Approve a pending claim (insurer only)
    // Input: _claimId
    function approveClaim(uint _claimId) external onlyInsurer {
        Claim storage claim = claims[_claimId];
        Policy storage policy = policies[claim.policyId];

        require(claim.status == ClaimStatus.Pending, "Not pending");
        require(claim.claimAmount <= policy.coverageAmount, "Exceeds coverage");
        require(claim.claimAmount <= getMaxAllowed(claim.reason), "Exceeds reason limit");

        claim.status = ClaimStatus.Approved;
        emit ClaimApproved(_claimId, claim.claimAmount);
    }

    // Reject a pending claim (insurer only)
    // Input: _claimId, _reason (text)
    function rejectClaim(uint _claimId, string memory _reason) external onlyInsurer {
        Claim storage claim = claims[_claimId];
        require(claim.status == ClaimStatus.Pending, "Not pending");

        claim.status = ClaimStatus.Rejected;
        emit ClaimRejected(_claimId, _reason);
    }

    // Pay an approved claim to claimant (insurer only)
    // Input: _claimId
    function payClaim(uint _claimId) external onlyInsurer {
        Claim storage claim = claims[_claimId];
        require(claim.status == ClaimStatus.Approved, "Not approved");

        claim.status = ClaimStatus.Paid;
        payable(claim.claimant).transfer(claim.claimAmount);
        emit ClaimPaid(_claimId, claim.claimant, claim.claimAmount);
    }

    // Check if a policy has expired and mark it as expired
    // Input: _policyId
    function checkPolicyExpiry(uint _policyId) external {
        Policy storage policy = policies[_policyId];
        if (policy.status == PolicyStatus.Active && block.timestamp > policy.startTime + policy.duration) {
            policy.status = PolicyStatus.Expired;
        }
    }

    // Get all policy IDs of a user
    function getUserPolicies(address _user) external view returns (uint[] memory) {
        return userPolicies[_user];
    }

    // Get all claim IDs against a policy
    function getPolicyClaims(uint _policyId) external view returns (uint[] memory) {
        return policyClaims[_policyId];
    }

    // Return full active policyholder list
    function getAllActiveAddresses() external view returns (address[] memory) {
        return activeAddresses;
    }

    // Return full cancelled policyholder list
    function getAllCancelledAddresses() external view returns (address[] memory) {
        return cancelledAddresses;
    }

    // Return full issued policyholder list
    function getAllIssuedAddresses() external view returns (address[] memory) {
        return issuedAddresses;
    }

    // Accept ETH into the contract (for claims payout)
    receive() external payable {}
}

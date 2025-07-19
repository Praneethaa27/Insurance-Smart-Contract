# Decentralized Insurance Management System on Ethereum Blockchain

**Abstract**

This project aims to implement a decentralized insurance management system using Solidity smart contracts on the Ethereum blockchain. It addresses the inefficiencies of traditional insurance systems by automating policy issuance, premium payment, claim submission, and claim processing. The decentralized nature of blockchain ensures transparency, security, immutability, and cost-efficiency.

**1. Problem Statement**
The current insurance industry faces several critical challenges:
- Manual, paper-based workflows causing delays and errors
- Centralized data prone to manipulation or loss
- Lack of transparency in policy tracking and claim processing
- Difficulty for policyholders to access real-time status of their insurance
- High administrative and operational costs

**2. Objective**
To build a secure, transparent, and efficient insurance platform on Ethereum where smart contracts automatically:
 - Issue and manage insurance policies
 - Track premium payments
 - Handle claim submissions and processing
- Manage policy cancellation, lapsing, and expiry
 - Record events for audit and transparency
**3. Roles and Responsibilities**
      Insurer (Admin):
- Deploys the contract
- Issues policies to users
- Approves or rejects claims
- Processes payouts
  
         Policyholder (User):
- Receives and activates a policy by paying the premium
- Submits claims
- Cancels inactive policies if needed
  
**4. Features and Functionalities**

	Policy Issuance: Insurer creates policies with premium, coverage, and duration in months/years.
	Premium Payment: User activates policy by sending the required Ether.
	Claim Submission: User submits reason and amount for claim.
	Claim Processing: Insurer approves/rejects claims based on rules.
	Claim Payout: If approved, the insurer pays the user.
	Policy Cancellation: Users may cancel unpaid policies.
	Lapsing Policies: Unpaid policies lapse after 7 days.
	Policy Expiry: Auto-expiry of active policies after end date.
	User Tracking: Functions to get all active, lapsed, or cancelled policyholders.

**5. Technology Stack**
- Language: Solidity (v0.8.x)
- IDE: Remix Ethereum IDE
- Testing Wallet: MetaMask
- Network: Ethereum Testnets (Goerli, Remix VM)
**6. Smart Contract Events for Transparency**
- PolicyIssued
- PremiumPaid
- ClaimSubmitted
- ClaimApproved
- ClaimRejected
- ClaimPaid
- PolicyCancelled
- PolicyLapsed
**7. Deployment & Testing Steps**
  - Open Remix IDE
  - Paste and compile smart contract code
  - Deploy to Remix VM or Goerli using MetaMask
  - Test each function:
   - Issue policy
          -> Pay premium
          -> Submit claim
          -> Approve/reject claim
          -> Pay claim
          -> Cancel or lapse policy
          -> Check expiry manually
     
**8. Future Enhancements**
- Integration with Chainlink for real-world claim validation
- Automated expiry/lapse via Chainlink Keepers
- Frontend using React + Web3.js
- Support for multiple insurance types: health, car, crop, etc.
- Risk-based dynamic premium adjustment

**Conclusion**

This project successfully translates a conventional insurance workflow into a secure, decentralized blockchain infrastructure. Smart contracts automate policies, premium payments, and claims, minimizing funnelling, error, and collusion.
Following interface development and external data validation through oracles, the system can be adopted in trust-based automated sectors such as health, vehicle, and crop insurance.





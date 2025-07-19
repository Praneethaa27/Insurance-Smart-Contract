# Decentralized Insurance Management System on Ethereum
# Insurance-Smart-Contract

## 📘 Overview

This project models a traditional insurance workflow on the Ethereum blockchain using Solidity smart contracts. It allows users to create insurance policies, pay premiums, file claims, and have them reviewed — all in a transparent, decentralized, and secure manner without the need for intermediaries.

## ✨ Key Features

- Create and manage insurance policies
- Pay premiums directly on-chain
- Submit and track claims
- Automatic status updates (Active, Expired, etc.)
- Owner-controlled approvals for claims

## 🛠️ Technologies Used

- **Solidity** for writing smart contracts
- **Remix IDE** or **Hardhat** for deployment and testing
- **Ethereum (EVM)** blockchain
- **MetaMask** (for interacting with contracts)
- **Ganache** or **Testnet (e.g., Sepolia)** for local or test deployment

## 🔍 Smart Contract Overview

The contract includes:

- `createPolicy()` – Policy creation by insurer
- `payPremium()` – Premium payment by policyholder
- `submitClaim()` – Claim submission for valid policies
- `approveClaim()` – Claim approval by insurer
- `getPolicy()` / `getClaim()` – Track policy and claim details

## 🚀 Getting Started

### Prerequisites

- Node.js & npm
- MetaMask wallet
- Remix IDE or Hardhat (optional for advanced devs)

### Steps to Run

1. Copy the smart contract code to [Remix IDE](https://remix.ethereum.org/)
2. Compile with Solidity 0.8.x
3. Deploy using "Injected Web3" (MetaMask) or Remix VM
4. Use the UI panel in Remix to call functions:
   - `createPolicy()`
   - `payPremium()`
   - `submitClaim()` etc.

## 📋 Usage Instructions

- The contract must be deployed by the insurer (owner).
- Policyholders use the contract to pay premiums and submit claims.
- The insurer reviews and approves claims.
- IDs for policies and claims are tracked within the contract and can be queried.

## 📈 Future Improvements

- Web3.js / Ethers.js frontend UI
- Oracle integration for real-world data (e.g., flight status, weather)
- Role-based access control
- Automated claim verification
- Real deployment on Ethereum Mainnet or Polygon

## 👤 Contributors

- [Your Name] – Smart Contract Developer  
- [Collaborator Name] – Documentation & Testing

## 📄 License

This project is licensed under the MIT License.

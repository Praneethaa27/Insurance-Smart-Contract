# Smart Contract Function Documentation

## createPolicy()
- Only owner (insurer) can call
- Inputs: premium, coverageAmount, duration
- Description: Creates a new insurance policy

## payPremium(policyId)
- Called by policyholder
- Sends Ether equal to policy premium
- Marks policy as Active

## submitClaim(policyId)
- Called by policyholder
- Creates a new claim for the active policy

## approveClaim(claimId)
- Only owner can approve
- Approves claim and transfers coverage amount

## getPolicy(policyId)
- Returns policy details

## getClaim(claimId)
- Returns claim details

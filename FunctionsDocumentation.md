# Smart Contract Function Documentation

## issuePolicy(address _policyholder, uint _premium, uint _coverageAmount, uint _months, uint _years)
- Called by insurer
- Issues a policy with duration converted to seconds
- Status set to `Inactive`

## payPremium(uint _policyId)
- Called by policyholder
- Requires exact premium amount
- Activates policy & sets startTime

## cancelPolicy(uint _policyId)
- Called by policyholder
- Cancels if unpaid and still inactive

## lapseUnpaidPolicy(uint _policyId)
- Called by anyone
- Lapses inactive policy after 7 days

## submitClaim(uint _policyId, uint _claimAmount, string _reason)
- Called by policyholder
- Policy must be active and not expired

## approveClaim(uint _claimId)
- Called by insurer
- Approves valid claims within coverage and reason-based limits

## rejectClaim(uint _claimId, string _reason)
- Called by insurer
- Marks claim as `Rejected`

## payClaim(uint _claimId)
- Called by insurer
- Transfers ETH to claimant and marks `Paid`

## checkPolicyExpiry(uint _policyId)
- Marks policy as `Expired` if duration passed

## getUserPolicies(address)
- Returns all policy IDs for a user

## getPolicyClaims(policyId)
- Returns all claims for a policy

## getAllIssuedAddresses() / getAllActiveAddresses() / getAllCancelledAddresses()
- Returns addresses by policy status category

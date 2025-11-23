# Base Access Fee Manager for Farecho (Farcaster Mini-App)

This repository documents the smart contract and pattern I use to manage access fees for my Farcaster mini-app **Farecho**, running on **Base mainnet**.

- Mini-app name: **Farecho**
- Mini-app link (Farcaster): https://farcaster.xyz/miniapps/U7FUwxLHV7p9/farecho

The goal of this setup is simple:

- Users log in to Farecho, a Farcaster mini-app.
- To access the app, they pay a fixed onchain fee (`0.00005 ETH` on Base).
- Instead of sending this fee directly to my EOA wallet, it is routed through a smart contract.
- This creates a transparent, onchain record of usage, revenue, and real builder activity on Base.

---

## Why I built this

Originally, Farecho was already live:

- Users connected with their Farcaster wallet.
- They paid an access fee.
- The fee was sent directly to my wallet.

This worked, but had some limitations:

1. **No clear onchain “builder footprint”**  
   Payments looked like random transfers instead of structured smart contract activity.

2. **Hard to track usage and revenue**  
   Without events or contract logs, there was no clear way to see analytics.

3. **Not future-proof**  
   Feature changes (like price tiers or subscriptions) would eventually require a contract.

So I created a simple and extensible contract-based pattern:

> A minimal **AccessFeeManager** contract that receives all Farecho access fees and allows the owner to withdraw the balance later.

---

## How it works (Farecho flow)

1. The user opens **Farecho** inside Farcaster and logs in using the native Farcaster/Neynar login flow.
2. Before full access, the user pays a fixed access fee of `0.00005 ETH`.
3. Instead of sending the payment directly to my wallet, the app now calls:
   - `to = AccessFeeManager` contract  
   - `value = 0.00005 ETH`  
   - `data = payAccess()`
4. The fee is stored safely in the contract.
5. I can withdraw all collected fees at any time using `withdrawAll()`.

This creates a clean onchain footprint and transparent usage tracking.

---

## Contract details

- **Network:** Base mainnet  
- **Contract name:** `AccessFeeManager`  
- **Contract address:** `0x12dbC9a0B45d735d82895a952F112Ee380a16671`

### Contract source

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessFeeManager {
    address public owner;
    uint256 public constant ACCESS_PRICE = 0.00005 ether;

    event AccessPaid(address indexed user, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function payAccess() external payable {
        require(msg.value == ACCESS_PRICE, "Must pay exactly 0.00005 ETH");
        emit AccessPaid(msg.sender, msg.value);
    }

    function withdrawAll() external {
        require(msg.sender == owner, "Not owner");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        payable(owner).transfer(balance);
        emit Withdraw(owner, balance);
    }
}
Key functions overview
🔹 payAccess()

Accepts exactly 0.00005 ETH

Emits AccessPaid

Called automatically when users enter Farecho

🔹 withdrawAll()

Only the deployer (owner) can call it

Transfers 100% of contract balance to owner

Integration with Farecho (mini-app)

Farecho mini-app link:
https://farcaster.xyz/miniapps/U7FUwxLHV7p9/farecho

The integration required only one change:

Instead of sending a plain ETH transfer to my wallet,
Farecho now triggers a contract call to payAccess() with 0.00005 ETH.

Everything else in the mini-app stays the same:

Same Farcaster login flow

Same UI

Same “click → sign → enter” experience

Just a different onchain target.

Notes for others who want to use this pattern

Contract assumes Base mainnet

owner = the wallet that deployed the contract

Never expose private keys or mnemonics

Test with small amounts first

Keep login/auth logic separate from payment logic

Only replace the payment target, not the authentication flow

Future enhancements

Adjustable pricing

Multiple access tiers

Free/discounted access lists

Dashboard with analytics based on AccessPaid events

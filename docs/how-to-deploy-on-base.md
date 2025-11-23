# How to deploy AccessFeeManager on Base (step by step)

This document explains how I deployed the `AccessFeeManager` contract on Base mainnet using Remix.

## 1. Create the contract

- Go to https://remix.ethereum.org
- Create `contracts/AccessFeeManager.sol`
- Paste the full contract code

## 2. Compile

- Open *Solidity Compiler*
- Select version **0.8.20**
- Click **Compile AccessFeeManager.sol**

## 3. Connect wallet to Base

Add Base network:

- RPC: https://mainnet.base.org  
- Chain ID: 8453  
- Explorer: https://basescan.org  

Switch wallet to Base.

## 4. Deploy

- Go to *Deploy & Run*
- Environment: **Injected Provider**
- Contract: **AccessFeeManager**
- Click **Deploy**
- Confirm in wallet

## 5. Test

- Call `ACCESS_PRICE`
- Call `payAccess()` with exactly `0.00005 ETH`
- Call `withdrawAll()` as owner

## 6. Integrate with Farecho

Replace your previous direct ETH transfer with:

- `to = AccessFeeManager`
- `value = 0.00005 ETH`
- `data = payAccess()`

User flow remains the same.

# Base Access Fee Manager for Farecho (Farcaster Mini-App)

This repository documents the smart contract and pattern I use to manage access fees for my Farcaster mini-app **Farecho**, running on **Base mainnet**.

- Mini-app name: **Farecho**
- Mini-app link (Farcaster): https://farcaster.xyz/miniapps/U7FUwxLHV7p9/farecho

---

## Why I built this

Originally, Farecho was already live:

- Users connected with their Farcaster wallet.
- They paid an access fee.
- The fee was sent directly to my wallet.

This worked, but had some limitations:

1. No clear onchain "builder footprint"
2. Hard to track usage & revenue
3. Not future-proof

So I created a simple contract pattern to make the flow onchain and transparent.

---

## Contract details

**Network:** Base mainnet  
**Contract name:** AccessFeeManager  
**Contract address:** `0x12dbC9a0B45d735d82895a952F112Ee380a16671`

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
```

---

## Key functions overview

### 🔹 payAccess()
- Accepts exactly **0.00005 ETH**
- Emits **AccessPaid**
- Called automatically inside Farecho

### 🔹 withdrawAll()
- Only deployer can call it
- Transfers 100% of contract balance

---

## Integration with Farecho

**Farecho mini-app link:**  
https://farcaster.xyz/miniapps/U7FUwxLHV7p9/farecho

Only 1 change was required:

❗ Instead of sending ETH directly to my wallet,  
Farecho now calls `payAccess()` with **0.00005 ETH**.

Everything else stayed the same:
- Same Farcaster login flow  
- Same UI  
- Same user experience  

---

## Notes for developers

- Contract must run on Base mainnet  
- Owner = deployer  
- Don’t expose private keys  
- Always test with small amounts  
- Only replace where payment is triggered  

---

## Future enhancements

- Adjustable fees  
- Free access list  
- Subscription model  
- Analytics via emitted events  

---

## TR Özet

Farecho’ya giriş yapan kullanıcılar `0.00005 ETH` öder.  
Bu ücret doğrudan cüzdana değil, önce kontrata gider.  
Ben `withdrawAll()` ile toplu çekerim.

Bu sistem:
- Onchain builder izi bırakır  
- Geliri şeffaf yapar  
- Gelecekte abonelik ve fiyatlandırma eklemeyi kolaylaştırır  

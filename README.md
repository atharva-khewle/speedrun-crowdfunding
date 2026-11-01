# Crowdfunding

![hero](packages/nextjs/public/hero.png)

A crowdfunding contract: contribute ETH to a goal before the deadline, or get refunded if it falls short.

- **Live demo:** https://crowdfunding-challenge-zeta.vercel.app
- **Contract (Sepolia):** [0x43642dF17c1BAa2DB9cd99fa0deEC656bf0fc632](https://sepolia.etherscan.io/address/0x43642dF17c1BAa2DB9cd99fa0deEC656bf0fc632)
- **Stack:** Scaffold-ETH 2, Foundry, Next.js, wagmi/viem

![screenshot](https://github.com/user-attachments/assets/1ad2365f-1e1a-4688-9f81-4bbef2a989d2)

## Tech and flow

- **Solidity**: `CrowdFund` holds contributions in a `balances` mapping with a 1 ETH threshold and a 2 hour deadline.
- **Foundry**: build, test, deploy to Sepolia.
- **Next.js + wagmi/viem + RainbowKit**: contribute, show time left, execute, withdraw.

```mermaid
flowchart TD
    U[Contributor] -->|contribute: send ETH| C[CrowdFund]
    C --> D{Deadline passed?}
    D -- no --> U
    D -- yes --> E[execute]
    E --> G{Balance >= 1 ETH?}
    G -- yes --> R[FundingRecipient.complete: funds sent]
    G -- no --> W[openToWithdraw = true]
    W -->|withdraw| U
```

Part of [SpeedRunEthereum](https://speedrunethereum.com).

# FundMe

A crowdfunding smart contract that accepts ETH contributions with a **USD-denominated minimum**, using a Chainlink Price Feed to convert ETH to USD in real time — rather than hardcoding a fixed ETH amount that would drift out of sync with the market.

## What it does

- Accepts ETH via `fund()`, requiring each contribution to be worth at least **$5 USD** at the time of the transaction
- Uses Chainlink's `AggregatorV3Interface` to pull the live ETH/USD exchange rate on-chain
- Tracks every contributor's address and cumulative amount funded (`mapping` + `array`)
- Restricts fund withdrawal to the contract deployer only, enforced via a custom `onlyOwner` modifier
- Accepts plain ETH transfers (sent without calling `fund()` directly) through `receive()` and `fallback()`, routing them through the same accounting logic

## Why Chainlink instead of a hardcoded price

Hardcoding "1 ETH = $X" would go stale the moment ETH's market price moves, making the minimum funding threshold meaningless within hours. Chainlink Price Feeds are decentralized oracle networks maintained by independent node operators, giving the contract a tamper-resistant, continuously updated price without the contract needing to trust any single off-chain source — this is the standard pattern for bringing real-world data on-chain.

## Concepts Practiced

| Concept | Where it's used |
|---|---|
| External contract calls | Calling `latestRoundData()` on a deployed Chainlink `AggregatorV3Interface` contract |
| Tuple destructuring | Unpacking Chainlink's 5-value return and discarding unused fields with empty commas |
| Type casting (`int256` → `uint256`) | Converting the signed price feed answer into an unsigned value usable in arithmetic with `msg.value` |
| Decimal precision handling | Scaling an 8-decimal price feed answer to match `msg.value`'s 18 decimals via `* 1e10` |
| `mapping` + dynamic `array` | Recording `addressToAmountFunded` and the `funders` list |
| Custom `modifier` | `onlyOwner` — reusable access-control check applied to `withdraw()` |
| Custom `error` | `NotOwner()` — gas-cheaper alternative to a `require` string revert |
| `immutable` / `constant` | `i_owner` set once in the constructor; `MINIMUM_USD` fixed at compile time — both cheaper to read than a regular state variable |
| `call{value: ...}("")` | The recommended low-level method for sending ETH out of a contract, checked with `require(success, ...)` |
| `receive()` / `fallback()` | Ensuring ETH sent without a function call still goes through the funding logic instead of getting stuck untracked |

## How to Run

### Remix IDE

1. Open [remix.ethereum.org](https://remix.ethereum.org)
2. Create a new file named `FundMe.sol` and paste the contract code
3. Go to the **Solidity Compiler** tab and compile (Remix automatically fetches the Chainlink import over the network — no manual install needed)
4. Go to **Deploy & Run Transactions**:
   - For local testing: select the **Remix VM** environment and deploy directly (note: `getLatestPrice()` will revert on Remix VM since there's no real Chainlink feed deployed there — this path is best for testing `fund()`'s bookkeeping logic with a modified/mocked price function)
   - For real price data: select **Browser Extension** (MetaMask), switch MetaMask to **Sepolia Testnet**, and deploy — this uses the live Sepolia ETH/USD feed at `0x694AA1769357215DE4FAC081bf1f309aDC325306`
5. Test the flow:
   - Enter an ETH amount in the **VALUE** field (e.g. `0.01`, unit `Ether`) worth more than $5, then call `fund()`
   - Call `addressToAmountFunded(<your address>)` to confirm the contribution was recorded
   - Call `withdraw()` from the **same account that deployed the contract** (set VALUE back to `0` first — `withdraw()` is not payable)
   - Calling `withdraw()` from any other account should revert with `NotOwner()`

### Foundry

```bash
forge install smartcontractkit/chainlink-brownie-contracts
forge build
```

## Live Deployment (Sepolia Testnet)

| | |
|---|---|
| **Contract Address** | [`0x23D826Ea98059e64eF0212e5fF56E790e1D0a37b`](https://sepolia.etherscan.io/address/0x23D826Ea98059e64eF0212e5fF56E790e1D0a37b) |
| **Verified Source** | [View on Sourcify](https://repo.sourcify.dev/11155111/0x23D826Ea98059e64eF0212e5fF56E790e1D0a37b/) — Exact Match ✅ |
| **Compiler** | solc 0.8.34 |

## Design Notes

- `MINIMUM_USD` is stored with 18 decimals (`5 * 1e18`) to match the precision `getConversionRate()` returns, avoiding a separate scaling step at the comparison site.
- `getConversionRate()` is `internal` since it's only ever needed by `fund()` itself, not by external callers.
- The Chainlink feed address is hardcoded rather than passed into the constructor — a production version would take the feed address as a constructor parameter so the same contract can be redeployed across networks (Sepolia, Mainnet, etc.) without editing the source.
- `funders` is reset with `new address[](0)` rather than looping to `.pop()` each element, which is simpler and avoids unnecessary gas spent on repeated array-length writes.

## License

MIT

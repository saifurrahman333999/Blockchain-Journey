# LearnToken (ERC-20)

A simple ERC-20 token built by extending OpenZeppelin's audited `ERC20` contract, rather than implementing the token standard from scratch.

## What it does

- Implements the full [EIP-20](https://eips.ethereum.org/EIPS/eip-20) standard interface (`transfer`, `balanceOf`, `approve`, `allowance`, `transferFrom`, `totalSupply`) via inheritance from OpenZeppelin
- Mints an initial supply to the deployer's address at deployment time
- Token name: **LearnToken**, symbol: **LRN**

## Why OpenZeppelin instead of writing it from scratch

OpenZeppelin's contracts are audited and battle-tested across thousands of production deployments. Reimplementing ERC-20 logic manually (transfer accounting, allowance tracking, overflow safety) introduces unnecessary risk for no real benefit — this is standard practice in real-world Solidity development.

## Concepts Practiced

| Concept | Where it's used |
|---|---|
| Inheritance (`is ERC20`) | Extending OpenZeppelin's contract to get all standard token behavior for free |
| Parent constructor calls | `ERC20("LearnToken", "LRN")` passes the token name/symbol up to the parent |
| `_mint` (inherited internal function) | Creating the initial token supply and assigning it to the deployer |
| Import statements | Pulling in external, audited library code with `import` |

## How to Run

### Remix IDE

1. Open [remix.ethereum.org](https://remix.ethereum.org)
2. Create a new file named `LearnToken.sol` and paste the contract code
3. Go to the **Solidity Compiler** tab and compile (Remix automatically fetches the OpenZeppelin import over the network — no manual install needed)
4. Go to **Deploy & Run Transactions**, select the **Remix VM** environment
5. In the constructor's `initialSupply` field, enter a value such as `1000000000000000000000` (this is 1000 tokens, accounting for 18 decimals — OpenZeppelin's default) and deploy
6. Test the flow:
   - Call `balanceOf(<your deployer address>)` — should show the full initial supply
   - Call `transfer(<another account address>, 100000000000000000000)` to send 100 tokens to a different test account
   - Call `balanceOf` on that second account to confirm it received the tokens
   - Call `totalSupply()` to confirm the total matches what was minted

### Foundry

```bash
forge install OpenZeppelin/openzeppelin-contracts
forge build
```

## Design Notes

- `initialSupply` is passed in the smallest unit, not "whole tokens" — this matches how ERC-20 amounts work on-chain, since `decimals()` defaults to 18 in OpenZeppelin's implementation.
- No minting function is exposed after deployment — supply is fixed at deploy time. A mintable/burnable version would require importing OpenZeppelin's `ERC20Burnable` or adding a custom `mint` function with access control.

## License

MIT

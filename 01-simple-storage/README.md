# Simple Storage

The most basic contract for storing and retrieving a single number on the
blockchain.

## What this teaches
- State variable (data that lives permanently on the blockchain)
- Public function
- `view` function (only reads, costs no gas)

## How to run it in Remix
1. Go to https://remix.ethereum.org/
2. Create a file named `SimpleStorage.sol` and paste in the code
3. Compile it
4. Deploy it on the "Remix VM" environment
5. Call `store(42)`, then call `retrieve()` — you should get `42`

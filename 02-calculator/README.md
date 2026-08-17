# Calculator

A contract that performs four basic math operations — add, subtract,
multiply, divide.

## What this teaches
- Functions that take parameters and return values
- `pure` functions (this contract has no state variables, it just computes
  and returns an answer — so like `view`, it costs no gas to call)
- Using `require()` to block invalid input (division by zero is blocked)
- Solidity 0.8+ automatically blocks overflow/underflow (`subtract(2, 5)`
  will error out on its own instead of wrapping into a huge number)

## How to run it in Remix
1. Paste `Calculator.sol` into Remix, compile it, deploy it (Remix VM)
2. `add(5, 3)` → returns 8
3. `subtract(2, 5)` → errors (expected, since the answer would be negative)
4. `divide(10, 0)` → errors with "Cannot divide by zero"

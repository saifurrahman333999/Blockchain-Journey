# Student Record

A small on-chain student list, used to practice combining a `struct` and an
`array`.

## What this teaches
- `struct` — grouping one student's name, roll, and CGPA into one custom
  type
- Array of structs — keeping a list of all students
- Public arrays automatically get a free getter from Solidity (so
  `students(0)` also works)
- Why CGPA is stored as `375` instead of `3.75` (Solidity has no decimals)

## How to run it in Remix
1. Paste `StudentRecord.sol` into Remix, compile it, deploy it (Remix VM)
2. Call `addStudent("Saifur Rahman", 1, 375)`
3. Call `addStudent("Rafi Ahmed", 2, 360)`
4. Call `totalStudents()` → returns `2`
5. Call `getStudent(0)` → returns the first student's info

# Processor Architecture

## 1. Overview

- Architectural objectives
- Supported instruction set
- Current microarchitecture
- Key design constraints

## 2. System Architecture

### 2.1 Datapath

<!-- Embed the overall processor architecture diagram. -->

### 2.2 Subsystem Responsibilities

| Subsystem | Responsibility | Documentation |
|---|---|---|
| Fetch | Instruction retrieval and PC management | [Fetch](modules/fetch.md) |
| Decode | Instruction decoding and operand retrieval | [Decode](modules/decode.md) |
| Execute | Computation and control-flow resolution | [Execute](modules/execute.md) |
| Memory and Writeback | Memory access and result selection | [Memory](modules/memory.md) |

## 3. Instruction Execution

### 3.1 Instruction Fetch

<!--
Describe:
- How the program counter (PC) identifies the current instruction.
- How instructions are retrieved from instruction memory.
- How the next sequential address is calculated.
- How branches and jumps redirect instruction execution.
- When the PC is updated.
-->

### 3.2 Instruction Decode

<!--
Describe:
- How the instruction is interpreted.
- How register addresses are extracted and operands retrieved.
- How immediate values are extracted and extended.
- How control signals are generated to coordinate subsequent operations.
-->

### 3.3 Execute

<!--
Describe:
- How ALU operands are selected.
- How arithmetic and logical operations are performed.
- How effective memory addresses are calculated.
- How branch conditions are evaluated.
- How branch and jump target addresses are calculated.
-->

### 3.4 Memory Access

<!--
Describe:
- How effective addresses are used to access data memory.
- How load and store operations are performed.
- How byte, halfword and word accesses are handled, where supported.
- What happens for instructions that do not require memory access.
-->

### 3.5 Writeback

<!--
Describe:
- The possible sources of writeback data.
- How the destination register is selected.
- When register updates occur.
- Which instructions do not perform register writeback.
- How the architectural requirement that x0 remains zero is maintained.
-->

## 4. Control Flow

<!--
- Sequential execution
- Conditional branches
- Unconditional jumps
- Subroutine calls and returns
-->

## 5. Memory Architecture

<!--
- Instruction and data memory organisation
- Memory map
- Addressing and alignment
- Endian convention
- Memory access timing
-->

## 6. Clocking and Reset

<!--
- Clocking strategy
- Reset behaviour
- Architectural state updates
- Timing assumptions
-->

## 7. Architectural Design Decisions

<!-- Link to relevant Architecture Decision Records. -->

## 8. Limitations

<!-- Document current architectural limitations and unsupported functionality. -->
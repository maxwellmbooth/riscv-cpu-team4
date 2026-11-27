# Processor Interface Specification

## 1. Overview

This document defines the interface contracts and shared conventions
between the processor's subsystems.

Its purpose is to ensure consistent and compatible implementation
across independently developed components.

Changes to interface specifications must be agreed upon by the
affected subsystem owners and documented alongside the corresponding
RTL changes.

**Architecture:** Single-cycle RV32I  (v1.0)
**Status:** Draft

---

## 2. Global Conventions

### 2.1 Signal Naming.

| Convention | Example | Description |
|---|---|---|
| `_i` | `instr_i` | Input port |
| `_o` | `pc_o` | Output port |
| `_curr` | `pc_curr` | Registered value |
| `_next` | `pc_next` | Next value of a register |
| `UPPER_CASE` | `DATA_WIDTH` | Parameters and constants |

**Additional conventions:**

- Signal names should clearly communicate their purpose
- Shared signals should use consistent terminology across subsystems
- Named port connections should be used when instantiating modules

### 2.2 Clocking

| Property | Specification |
|---|---|
| Clock domains | Single global clock |
| Active clock edge | Rising edge |
| Register file read | Asynchronous |
| Register file write | Synchronous |
| Instruction memory read | Async/Sync - TBD |
| Data memory read | Async/Sync - TBD |
| Data memory write | Async/Sync - TBD |

**Clocking requirements:**

- Sequential state updates occur on the agreed active clock edge
- Combinational outputs must settle before being sampled by
  sequential components
- Individual subsystems must not generate independent clocks
  unless explicitly agreed upon

### 2.3 Reset

| Property | Specification |
|---|---|
| Reset polarity | Active high/low - TBD |
| Reset timing | Asynchronous |
| PC reset address | 0x00000000 |
| Register file reset behaviour | TBD |
| Instruction memory reset behaviour | Retain initialised contents/clear - TBD |
| Data memory reset behaviour | TBD |
| Reset priority | Takes precedence over normal operation |

**Additional requirements:**

- Reset behaviour must be consistent across all subsystems
- Reset must be compatible with the supplied verification framework
- Register and memory writes during reset must follow the agreed
  reset policy

### 2.4 Data and Address Widths

| Signal Category | Width (bits) | Description |
|---|---:|---|
| Instruction | 32 | Standard RV32I instruction |
| Register data | 32 | Architectural register width |
| Register index | 5 | Addresses one of 32 registers |
| Program counter | 32 | Current instruction byte address |
| Memory address | 32 | Architectural byte address |
| ALU operand | 32 | Arithmetic or logical operand |
| ALU result | 32 | Arithmetic or logical result |
| Extended immediate | 32 | Decoded immediate value |
| Boolean control signal | 1 | Binary control value |
| ALU operation | TBD | Encoded ALU operation |
| Branch operation | TBD | Encoded branch condition |
| Memory operation | TBD | Encoded memory operation |
| Writeback selection | TBD | Encoded writeback source |

**Additional conventions:**

| Property | Specification |
|---|---|
| Addressing | Byte-addressable |
| Endianness | Little-endian |
| Instruction alignment | 4 bytes |
| Data access alignment | TBD |
| Default signal signedness | Unsigned/Signed - TBD |
| Signed arithmetic | Explicit signed interpretation |
| Immediate extension | According to RV32I instruction semantics |
| Memory capacity | Refer to architecture.md |

### 2.5 Signal Encoding

Signal encodings define the mapping between binary control values
and their corresponding hardware operations

**Encoding conventions:**

- Boolean control signals are active high/ low (TBD) unless explicitly
  specified otherwise
- Multi-bit control signals use shared, agreed encodings
- Named constants or enumerated types should be used instead
  of hardcoded binary values
- Reserved and unsupported encodings must have defined behaviour
- Shared encodings must not be independently redefined by
  individual subsystems

Shared control encodings are specified in Section 5

---

## 3. Top-Level Interface

The processor's external interface must remain compatible with
the supplied coursework verification framework.

| Signal | Direction | Width (bits) | Description |
|---|---|---:|---|
| `clk` | Input | 1 | Global processor clock |
| `rst` | Input | 1 | Processor reset |
| `trigger` | Input | 1 | External trigger input |
| `a0` | Output | 32 | Architectural value of register x10 |

### Timing & Validity

- `clk`: Refer to Section 2.2
- `rst`: Refer to Section 2.3
- `trigger`: TBD 
- `a0`: TBD

### Assumptions & Constraints

- The top-level module must remain compatible with the supplied
  verification framework
- External port names and widths must not be changed without
  verifying compatibility

---

## 4. Inter-Subsystem Interfaces

This section defines the signals exchanged between subsystems.

Each interface specifies:

- Signal names, widths and responsibilities
- Timing and validity requirements
- Assumptions and constraints

Signal directions are relative to the producing and consuming
subsystems.

<!--
TODO

Timing & Validity:
- When is the signal generated?
- Is it combinational or registered?
- When does it contain meaningful information?
- When is it sampled by the receiving subsystem?

Assumptions & Constraints:
- What does the producer guarantee?
- What can the consumer assume?
- What input values or behaviours are unsupported?
- Which subsystem is responsible for particular operations?
-->

### 4.1 Fetch → Decode

| Signal | Width (bits) | Description |
|---|---:|---|
| `instr` | 32 | Current machine instruction |
| `pc` | 32 | Byte address of the current instruction |
| `pc_plus4` | 32 | Sequential instruction address |

#### Timing & Validity

- Instructions become available combinationally following
  changes to the program counter.
- The instruction, PC and PC + 4 must correspond to the
  same instruction.
- Outputs must settle within the current clock period.
- Behaviour during reset: TBD.

#### Assumptions & Constraints

- Instructions are 32 bits wide.
- Compressed instructions are not supported.
- The PC represents a byte address, not a word index.
- Instructions are four-byte aligned.
- Behaviour for invalid instruction addresses: TBD.

---

### 4.2 Decode → Execute

| Signal | Width (bits) | Description |
|---|---:|---|
| `pc` | 32 | Address of the current instruction |
| `pc_plus4` | 32 | Sequential instruction address |
| `rs1_data` | 32 | First source register value |
| `rs2_data` | 32 | Second source register value |
| `imm` | 32 | Extended immediate value |
| `rs1` | 5 | First source register index, if required |
| `rs2` | 5 | Second source register index, if required |
| `rd` | 5 | Destination register index |
| `alu_op` | TBD | ALU operation selection |
| `alu_src_a` | TBD | First ALU operand selection |
| `alu_src_b` | TBD | Second ALU operand selection |
| `branch_en` | 1 | Conditional branch enable |
| `branch_op` | TBD | Branch comparison operation |
| `jump_op` | TBD | Jump operation selection |
| `mem_read` | 1 | Memory read enable |
| `mem_write` | 1 | Memory write enable |
| `mem_size` | TBD | Memory access width |
| `mem_unsigned` | 1 | Unsigned load selection |
| `reg_write` | 1 | Register write enable |
| `wb_sel` | TBD | Writeback source selection |

#### Timing & Validity

- Operands and control signals are generated combinationally
  following instruction decoding.
- All signals must correspond to the same instruction.
- Immediate values are meaningful when required by the
  decoded instruction.
- Branch operation selection is meaningful when conditional
  branch execution is enabled.
- Memory control signals are meaningful for the corresponding
  memory operations.
- Behaviour during reset: TBD.

#### Assumptions & Constraints

- Immediate values have already been appropriately extended.
- Control signals conform to the encodings in Section 5.
- Register operands correspond to the decoded source registers.
- Unsupported instructions must not cause unintended
  architectural state changes.
- Illegal or reserved instruction handling: TBD.

---

### 4.3 Execute → Memory

| Signal | Width (bits) | Description |
|---|---:|---|
| `alu_result` | 32 | Computation result or effective memory address |
| `store_data` | 32 | Data to be written to memory |
| `pc_plus4` | 32 | Return address for jump-and-link instructions |
| `rd` | 5 | Destination register index |
| `mem_read` | 1 | Memory read enable |
| `mem_write` | 1 | Memory write enable |
| `mem_size` | TBD | Memory access width |
| `mem_unsigned` | 1 | Unsigned load selection |
| `reg_write` | 1 | Register write enable |
| `wb_sel` | TBD | Writeback source selection |

#### Timing & Validity

- ALU results are generated combinationally.
- The effective memory address is meaningful when a memory
  read or write is enabled.
- Store data is meaningful when memory writing is enabled.
- Memory write inputs must be stable around the agreed
  capturing clock edge.
- Writeback controls must correspond to the current instruction.
- Behaviour during reset: TBD.

#### Assumptions & Constraints

- Effective addresses are byte addresses.
- Address calculation has already been performed by execute.
- Accesses must comply with the supported memory map.
- Accesses must comply with the agreed alignment policy.
- Memory read and write enables must not both be asserted
  for the same instruction.
- Behaviour for unsupported or out-of-range accesses: TBD.

---

### 4.4 Execute → Fetch

| Signal | Width (bits) | Description |
|---|---:|---|
| `redirect` | 1 | Indicates that control flow must be redirected |
| `redirect_addr` | 32 | Byte address of the next instruction |

#### Functional Contract

| `redirect_valid` | Next PC |
|---|---|
| `0` | Current PC + 4 |
| `1` | `redirect_addr` |

#### Timing & Validity

- Redirect signals are generated combinationally by execute.
- `redirect_addr` is meaningful only when `redirect`
  is asserted
- Fetch uses these signals to calculate the next PC
- The next PC is captured on the rising clock edge
- Redirect signals must satisfy the setup and hold requirements
  of the receiving PC register

#### Assumptions & Constraints

- Execute evaluates conditional branch outcomes
- Execute calculates branch and jump target addresses
- Execute performs the required bit-zero clearing for JALR
- Fetch does not distinguish between branch and jump
  instruction types
- Valid redirect addresses are four-byte aligned
- Valid redirect addresses fall within the supported instruction
  memory region
- Reset takes precedence over redirection
- Invalid redirect address handling: TBD

---

### 4.5 Writeback → Decode

| Signal | Width (bits) | Description |
|---|---:|---|
| `wb_data` | 32 | Value to be written to the register file |
| `wb_rd` | 5 | Destination register index |
| `reg_write` | 1 | Register write enable |

#### Timing & Validity

- Writeback data is selected combinationally from the
  available result sources
- `wb_data` and `wb_rd` are meaningful when `reg_write`
  is asserted
- Register updates occur on the agreed active clock edge
- Writeback signals must satisfy the setup and hold
  requirements of the register file
- Behaviour during reset: TBD

#### Assumptions & Constraints

- The writeback subsystem selects the correct result source
- The destination register index corresponds to the
  instruction being executed
- The register file must prevent modification of register x0
- No register update occurs when `reg_write` is deasserted

---

## 5. Shared Control Signal Encodings

This section defines the binary encodings of control signals
shared between subsystems

### 5.1 ALU Operations

**Signal:** `alu_op`  
**Width:** 4 bits

| Encoding | Constant | Operation |
|---|---|---|
| `0000` | `ADD` | Addition |
| `0001` | `SUB` | Subtraction |
| `0010` | `AND` | Bitwise AND |
| `0011` | `OR` | Bitwise OR |
| `0100` | `XOR` | Bitwise XOR |
| `0101` | `SLL` | Logical left shift |
| `0110` | `SRL` | Logical right shift |
| `0111` | `SRA` | Arithmetic right shift |
| `1000` | `SLT` | Signed less-than comparison |
| `1001` | `SLTU` | Unsigned less-than comparison |
| Remaining | X | Reserved |

**Reserved encoding behaviour:** TBD

### 5.2 Operand Selection

#### Operand A

**Signal:** `alu_src_a`  
**Width:** 2 bits

| Encoding | Constant | Operand Source |
|---|---|---|
| `00` | `ZERO` | Constant zero |
| `01` | `RS1` | First source register |
| `10` | `PC` | Current program counter |
| `11` | X | Reserved |

#### Operand B

**Signal:** `alu_src_b`  
**Width:** 1 bit

| Encoding | Constant | Operand Source |
|---|---|---|
| `0` | `RS2` | Second source register |
| `1` | `IMM` | Extended immediate |

**Reserved encoding behaviour:** TBD

### 5.3 Branch and Jump Operations

#### Conditional Branches

**Signal:** `branch_op`  
**Width:** 3 bits

The proposed encodings correspond to the RV32I branch funct3
field

| Encoding | Constant | Condition |
|---|---|---|
| `000` | `BEQ` | Equal |
| `001` | `BNE` | Not equal |
| `100` | `BLT` | Signed less than |
| `101` | `BGE` | Signed greater than or equal |
| `110` | `BLTU` | Unsigned less than |
| `111` | `BGEU` | Unsigned greater than or equal |
| Remaining | X | Reserved |

The branch operation is meaningful only when `branch_en`
is asserted

#### Unconditional Jumps

**Signal:** `jump_op`  
**Width:** 2 bits

| Encoding | Constant | Operation |
|---|---|---|
| `00` | `J_NONE` | No unconditional jump |
| `01` | `JAL` | PC-relative jump |
| `10` | `JALR` | Register-relative jump |
| `11` | X | Reserved |

**Reserved encoding behaviour:** TBD

### 5.4 Memory Operations

#### Memory Control Signals

| Signal | Width (bits) | Description |
|---|---:|---|
| `mem_read` | 1 | Enable memory read |
| `mem_write` | 1 | Enable memory write |
| `mem_size` | 2 | Select memory access width |
| `mem_unsigned` | 1 | Select unsigned load extension |

#### Access Width

| `mem_size` | Constant | Access Width |
|---|---|---|
| `00` | `MEM_BYTE` | 8 bits |
| `01` | `MEM_HALF` | 16 bits |
| `10` | `MEM_WORD` | 32 bits |
| `11` | X | Reserved |

#### Load Extension

| `mem_unsigned` | Behaviour |
|---|---|
| `0` | Sign-extend loaded data |
| `1` | Zero-extend loaded data |

#### Example Instruction Control Values

| Instruction | `mem_read` | `mem_write` | `mem_size` | `mem_unsigned` |
|---|---|---|---|---|
| LB | 1 | 0 | `00` | 0 |
| LBU | 1 | 0 | `00` | 1 |
| LH | 1 | 0 | `01` | 0 |
| LHU | 1 | 0 | `01` | 1 |
| LW | 1 | 0 | `10` | X |
| SB | 0 | 1 | `00` | X |
| SH | 0 | 1 | `01` | X |
| SW | 0 | 1 | `10` | X |
| Non-memory instruction | 0 | 0 | X | X |

X indicates that the signal is irrelevant to the
operation

**Reserved encoding behaviour:** TBD

### 5.5 Writeback Selection

**Signal:** `wb_sel`  
**Width:** 2 bits

| Encoding | Constant | Writeback Source |
|---|---|---|
| `00` | `WB_ALU` | ALU result |
| `01` | `WB_MEM` | Loaded memory data |
| `10` | `WB_PC4` | PC + 4 |
| `11` | X | Reserved |

Register writing is controlled independently by `reg_write`

#### Example Instruction Control Values

| Instruction | `wb_sel` | `reg_write` |
|---|---|---|
| ADD | `00` | 1 |
| ADDI | `00` | 1 |
| LW | `01` | 1 |
| JAL | `10` | 1 |
| JALR | `10` | 1 |
| SW | X | 0 |
| BEQ | X | 0 |

**Reserved encoding behaviour:** TBD

---

## 6. Interface Change Policy

Changes to established interface contracts must follow the
following process:

1. Identify the required change and affected subsystems
2. Discuss the change with the relevant subsystem owners
3. Agree upon the revised interface specification
4. Update the interface documentation and shared RTL definitions
5. Implement the corresponding RTL changes
6. Update and execute relevant unit and integration tests
7. Include documentation and verification changes in the
   corresponding pull request

Interface changes must not introduce undocumented incompatibilities
between subsystems.

Significant architectural interface changes should also be
recorded in an Architecture Decision Record where appropriate.

---

## 7. References

- [Processor Architecture](architecture.md)
- [Verification Strategy](verification.md)
- [Module Documentation](modules/)
- [Architecture Decision Records](design-decisions/)
- [Processor Diagrams](diagrams/)

# riscv-cpu-team4
## Execute
### ALU
- Full RV32I compliant ALU with signed and unsigned operations
- Uses `alu_op_t` enum to determine operation (to be set in control unit)
- Note: JAL is the only branch operation to use the ALU so it must be set accordingly
### Regfile
- Standard 32 general purpose register file (`x0` tied to '0)
- Synchromnous write, asynchronous read
- Separate write enable signal
### Branch Unit
- Full RV32I compliant branch unit using ALU compare results
- Uses `branch_op_t` enum to determine operation (to be set in control unit)
- Outputs `pc_redirect_t` with a branch taken when `valid` is set and the PC should take the `target` address for the next cycle
## Package Descriptions (/rtl/pkg)
- `riscv_pkg.sv` contains enums/structures defined by the RV32I specification
- `core_pkg.sv` contains enums/structures that the core uses but are not defined by the specification
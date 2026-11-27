module top
    import riscv_pkg::*;
    import core_pkg::*;
(
    input logic clk_i, rst_i
);

    // Regfile instance
    logic [4:0] rs1_addr, rs2_addr, rd_addr;
    logic [XLEN-1:0] rd_data;
    logic rd_we;
    logic [XLEN-1:0] rs1_data, rs2_data;
    
    regfile regfile_inst (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .rs1_addr_i(rs1_addr),
        .rs2_addr_i(rs2_addr),
        .rd_addr_i(rd_addr),
        .rd_data_i(rd_data),
        .rd_we_i(rd_we),
        .rs1_data_o(rs1_data),
        .rs2_data_o(rs2_data)
    );

    // Program counter instance
    logic [XLEN-1:0] pc;
    pc_redirect_t pc_redirect; // struct containing pc_redirect info (valid will be 1 if branch is to be taken next cycle and target will contain the address to set PC to next cycle)

    // Control unit instance
    alu_a_sel_t alu_a_sel;
    alu_b_sel_t alu_b_sel;
    alu_op_t alu_op; // enum of all ALU ops, use ALU_INVALID if no alu op
    branch_op_t branch_op; // enum of all BRANCH ops, use BRANCH_INVALID if no branch op

    // IMM generator instance (put under CU if the imm_gen becomes part of that)
    logic [XLEN-1:0] imm;

    // ALU instance
    logic [XLEN-1:0] alu_a, alu_b, alu_res;
    logic alu_eq, alu_lt, alu_ltu;

    always_comb begin
        // ALU A input selection
        unique case (alu_a_sel)
            ALU_A_SEL_RS1: alu_a = rs1_data;
            ALU_A_SEL_PC: alu_a = pc;
            default: alu_a = rs1_data;
        endcase
        
        // ALU B input selection 
        unique case (alu_b_sel)
            ALU_B_SEL_RS2: alu_b = rs2_data;
            ALU_B_SEL_IMM: alu_b = imm;
            default: alu_b = rs2_data;
        endcase
    end

    alu alu_inst (
        .a_i(alu_a),
        .b_i(alu_b),
        .op_i(alu_op),
        .res_o(alu_res),
        .eq_o(alu_eq),
        .lt_o(alu_lt),
        .ltu_o(alu_ltu)
    );

    // Branch unit instance
    branch_unit branch_unit_inst (
        .branch_op_i(branch_op),
        .alu_eq_i(alu_eq),
        .alu_lt_i(alu_lt),
        .alu_ltu_i(alu_ltu),
        .pc_i(pc),
        .imm_i(imm),
        .alu_res_i(alu_res),
        .pc_redirect_o(pc_redirect)
    );

endmodule
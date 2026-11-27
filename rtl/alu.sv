module alu  
    import riscv_pkg::*;
(
    input logic [XLEN-1:0] a_i,
    input logic [XLEN-1:0] b_i,
    input alu_op_t op_i,
    
    output logic [XLEN-1:0] res_o,
    output logic eq_o, lt_o, ltu_o
);
    
    assign eq_o = (a_i == b_i);
    assign lt_o = ($signed(a_i) < $signed(b_i));
    assign ltu_o = (a_i < b_i);
    
    always_comb begin
        unique case(op_i)
            ALU_INVALID: res_o = '0;
            ALU_ADD: res_o = a_i + b_i;
            ALU_SUB: res_o = a_i - b_i;
            ALU_SLT: res_o = lt_o? 'd1 : 'd0;
            ALU_SLTU: res_o = ltu_o? 'd1 : 'd0;
            ALU_SLL: res_o = a_i << b_i[4:0];
            ALU_SRL: res_o = a_i >> b_i[4:0];
            ALU_SRA: res_o = $signed(a_i) >>> b_i[4:0];
            ALU_OR: res_o = a_i | b_i;
            ALU_XOR: res_o = a_i ^ b_i;
            ALU_AND: res_o = a_i & b_i;
            default: res_o = '0;
        endcase
    end
    
    
endmodule
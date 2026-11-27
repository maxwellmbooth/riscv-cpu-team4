module branch_unit  
    import riscv_pkg::*;
    import core_pkg::*;
(
    input branch_op_t branch_op_i,
    input logic alu_eq_i, 
    input logic alu_lt_i, 
    input logic alu_ltu_i,
    input logic [XLEN-1:0] pc_i,
    input logic [XLEN-1:0] imm_i,
    input logic [XLEN-1:0] alu_res_i,

    output pc_redirect_t pc_redirect_o
);

    always_comb begin
        unique case (branch_op_i)
            BRANCH_INVALID: begin
                pc_redirect_o = '0;
            end
            
            BEQ: begin
                pc_redirect_o.valid = alu_eq_i;
                pc_redirect_o.target = pc_i + imm_i;
            end
            
            BNE: begin
                pc_redirect_o.valid = !alu_eq_i;
                pc_redirect_o.target = pc_i + imm_i;
            end
            
            BLT: begin
                pc_redirect_o.valid = alu_lt_i;
                pc_redirect_o.target = pc_i + imm_i;
            end
            
            BGE: begin
                pc_redirect_o.valid = !alu_lt_i;
                pc_redirect_o.target = pc_i + imm_i;
            end
            
            BLTU: begin
                pc_redirect_o.valid = alu_ltu_i;
                pc_redirect_o.target = pc_i + imm_i;
            end
            
            BGEU: begin
                pc_redirect_o.valid = !alu_ltu_i;
                pc_redirect_o.target = pc_i + imm_i;
            end
            
            JAL: begin
                pc_redirect_o.valid = 1'b1;
                pc_redirect_o.target = alu_res_i;
            end
            
            JALR: begin
                pc_redirect_o.valid = 1'b1;
                pc_redirect_o.target = {alu_res_i[XLEN-1:1], 1'b0}; // mask with ~1 to avoid odd PC writes
            end
            default: pc_redirect_o = '0;
        endcase
    end
    
endmodule
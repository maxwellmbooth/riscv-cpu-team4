module writeback
    import riscv_pkg::*;
    import core_pkg::*;
    //rd_sel comes from core and XLEN comes from riscv 
(
    input rd_sel_t  rd_sel_i,//what source to writeback
    input logic [XLEN -1:0] alu_result_i,//add or addi
    input logic [XLEN -1:0] imm_i , //lui
    input logic [XLEN -1:0] load_data_i, 
    input logic [XLEN -1:0] pc_plus4_i, //(return address)
    output logic [XLEN -1:0] rd_data_o //to regile 

);

always_comb begin 
    case(rd_sel_i)
        RD_SEL_MEM: rd_data_o = load_data_i;
        RD_SEL_PC:  rd_data_o = pc_plus4_i;
        RD_SEL_IMM: rd_data_o = imm_i;
        default:    rd_data_o = alu_result_i;   // RD_SEL_ALU
    endcase

end 
endmodule 

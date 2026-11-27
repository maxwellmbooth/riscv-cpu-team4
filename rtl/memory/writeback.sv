module writeback(
    input logic [1:0]   wb_sel_i, //00 is ALU, 01 memory, 10 PC + 4
);

always comb begin 
    case(wb_sel_i)
        //01 is memory
        2'b01: wb_data_o //mem
        2'b10: //pc+4
        2'b00 //alu
        default: wb_data_o = alu_result_i;
    endcase

end 
endmodule 

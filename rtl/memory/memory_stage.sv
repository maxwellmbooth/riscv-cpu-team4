module memory_stage(
    




);

    logic [3:0] byte_en;
    logic [31:0] raw;



    always_comb begin
        case(mem_size_i)
            //00 is 1 byte
            //01 is 2 byte 
            //10 is 4 bytes
        
        endcase
    end

endmodule
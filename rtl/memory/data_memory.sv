module data_memory (
    parameter ADDR_WIDTH = 17 
)(
    input logic     clk_i,
    input logic [ADDR_WIDTH - 1:0]     addr_i,
    input logic     byte_en_i, //which bytes to write 
    input logic [31:0]  wdata_i,       
    input logic [31:0]  rdata_o


    //4 bytes from addr

    
);


    //storage 
    //work out the addresses of the 3 bytes after addr_i

    //split mem into 3 parts 
    
    logic[7:0] mem


    assign a1 = addr_i + ADDR_WIDTH'(1);
    assign a2 = addr_i + ADDR_WIDTH'(2);
    assign a3 = addr_i + ADDR_WIDTH'(3);




    always_ff @ (posedge clk_i) begin
        if .... 

        //check switch number 0, if its 1 write that byte if its off, leave that byte alone





    end 

endmodule 
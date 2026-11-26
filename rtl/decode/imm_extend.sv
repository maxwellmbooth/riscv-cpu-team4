module imm_extend(
    input logic [2:0] imm_src,
    input logic [31:7] imm_input,
    output logic[31:0] imm_ext
);
always_comb begin
        case (imm_src)
            // I-type
            3'd0: imm_ext = {{20{imm_input[31]}}, imm_input[31:20]};

            // S-type
            3'd1: imm_ext = {{20{imm_input[31]}}, imm_input[31:25], imm_input[11:7]};

            // B-type
            3'd2: imm_ext = {{19{imm_input[31]}}, imm_input[31], imm_input[7],
                           imm_input[30:25], imm_input[11:8], 1'b0};

            // U-type
            3'd3: imm_ext = {imm_input[31:12], 12'b0};

            // J-type
            3'd4: imm_ext = {{11{imm_input[31]}}, imm_input[31], imm_input[19:12],
                           imm_input[20], imm_input[30:21], 1'b0};

            default: imm_ext = {{20{imm_input[31]}}, imm_input[31:20]};
        endcase
    end
endmodule

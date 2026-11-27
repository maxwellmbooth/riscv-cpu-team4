package core_pkg;
    import riscv_pkg::*;

    // ENUMS
    // ALU A mux options
    typedef enum logic {
        ALU_A_SEL_RS1,
        ALU_A_SEL_PC
    } alu_a_sel_t;
    
    // ALU B mux options
    typedef enum logic [1:0] {
        ALU_B_SEL_RS2,
        ALU_B_SEL_IMM
    } alu_b_sel_t;
    
    // RD mux options
    typedef enum logic[1:0] {
        RD_SEL_ALU,
        RD_SEL_IMM,
        RD_SEL_MEM,
        RD_SEL_PC
    } rd_sel_t;

    // STRUCTS
    // PC redirect
    typedef struct packed {
        logic valid;
        logic [XLEN-1:0] target;
    } pc_redirect_t;
    
    // Control signals per instruction
    typedef struct packed {
        alu_a_sel_t alu_a_sel;
        alu_b_sel_t alu_b_sel;
        alu_op_t alu_op;
        branch_op_t branch_op;
        store_op_t store_op;
        load_op_t load_op;
        rd_sel_t rd_sel;
        logic rd_we;
        logic mem_we;
        logic mem_re;
    } ctrl_signals_t;

endpackage
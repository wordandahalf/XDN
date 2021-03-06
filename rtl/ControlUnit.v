`timescale 1ps / 1ps
module ControlUnit
(
    input                               i_CLOCK,        // Clock input
    input   [DATA_WIDTH - 1:0]          i_IR_DATA,      // Instruction register data, contans the opcode of the current instruction
    input                               i_ZERO_FLAG,
    input                               i_CARRY_FLAG,
    input                               i_ADVANCE,      // Instructs the CU to advance to the next instruction

    output                              o_CLEAR,
    output                              o_CLEAR_n,
    output  [CONTROL_WIDTH - 1:0]       o_CONTROL_SIGNALS
);

    parameter   DATA_WIDTH      = 8;

    // Keeps track of instruction decoding
    reg [2:0]   r_T_CYCLE       = 0;

    `include "rtl/ControlSignals.v"

    // Updates t-cycle counter
    always @(posedge i_CLOCK)
    begin
        // Update the clock
        if((r_T_CYCLE == 'h6) || (i_ADVANCE))
            r_T_CYCLE <= 0;
        else
            r_T_CYCLE <= r_T_CYCLE + 1'b1;
    end

    assign o_CLEAR = 0;
    assign o_CLEAR_n = 1;
    assign o_CONTROL_SIGNALS =
        (r_T_CYCLE == 'h0) ? c_PC_OUT | c_MAR_IN :              //---|
                                                                //   | Fetch
        (r_T_CYCLE == 'h1) ? c_RAM_OUT | c_IR_IN | c_PC_INC :   //---|
        (i_IR_DATA == 'h10) ?    // LDA; A = RAM[IMM4]
            r_T_CYCLE == 'h2 ?  c_PC_OUT | c_MAR_IN     :
            r_T_CYCLE == 'h3 ?  c_RAM_OUT | c_MAR_IN    :
            r_T_CYCLE == 'h4 ?  c_PC_INC | c_RAM_OUT | c_A_IN      :
            c_CU_ADVANCE :
        (i_IR_DATA == 'h20) ?    // ADD; B = RAM[IMM4], A += B
            r_T_CYCLE == 'h2 ?  c_PC_OUT  | c_MAR_IN    :
            r_T_CYCLE == 'h3 ?  c_RAM_OUT | c_MAR_IN    :
            r_T_CYCLE == 'h4 ?  c_RAM_OUT | c_B_IN      :
            r_T_CYCLE == 'h5 ?  c_PC_INC | c_ALU_OUT | c_A_IN | c_FLAGS_UPDATE :
            c_CU_ADVANCE :
        (i_IR_DATA == 'h30) ?    // SUB; B = RAM[IMM4], A -= B
            r_T_CYCLE == 'h2 ?  c_PC_OUT  | c_MAR_IN    :
            r_T_CYCLE == 'h3 ?  c_RAM_OUT | c_MAR_IN    :
            r_T_CYCLE == 'h4 ?  c_RAM_OUT | c_B_IN      :
            r_T_CYCLE == 'h5 ?  c_PC_INC | c_ALU_OUT | c_A_IN | c_FLAGS_UPDATE | c_ALU_SUB :
            c_CU_ADVANCE :
        (i_IR_DATA == 'h40) ?    // LDI; A = IMM4
            r_T_CYCLE == 'h2 ?  c_PC_OUT  | c_MAR_IN    :
            r_T_CYCLE == 'h3 ?  c_PC_INC | c_RAM_OUT | c_A_IN      :
            c_CU_ADVANCE :
        (i_IR_DATA == 'h50) ?    // ADDI; A += IMM4
            r_T_CYCLE == 'h2 ?  c_PC_OUT  | c_MAR_IN    :
            r_T_CYCLE == 'h3 ?  c_PC_INC | c_RAM_OUT | c_B_IN       :
            r_T_CYCLE == 'h4 ?  c_ALU_OUT | c_A_IN | c_FLAGS_UPDATE :
            c_CU_ADVANCE :
        (i_IR_DATA == 'h60) ?    // SUBI; A -= IMM4
            r_T_CYCLE == 'h2 ?  c_PC_OUT  | c_MAR_IN    :
            r_T_CYCLE == 'h3 ?  c_PC_INC | c_RAM_OUT | c_B_IN       :
            r_T_CYCLE == 'h4 ?  c_ALU_OUT | c_ALU_SUB | c_A_IN | c_FLAGS_UPDATE :
            c_CU_ADVANCE :
        (i_IR_DATA == 'h70) ?    // STA; RAM[IMM4] = A
            r_T_CYCLE == 'h2 ?  c_PC_OUT  | c_MAR_IN    :
            r_T_CYCLE == 'h3 ?  c_RAM_OUT  | c_MAR_IN    :
            r_T_CYCLE == 'h4 ?  c_PC_INC | c_A_OUT | c_RAM_IN      :
            c_CU_ADVANCE :
        (i_IR_DATA == 'h80) ?    // JMP; PC = IMM4
            r_T_CYCLE == 'h2 ?  c_PC_OUT  | c_MAR_IN    :
            r_T_CYCLE == 'h3 ?  c_PC_INC | c_RAM_OUT | c_JUMP     :
            c_CU_ADVANCE :
        (i_IR_DATA == 'h90) ?    // JZ; if(ZERO_FLAG) PC = IMM4
            r_T_CYCLE == 'h2 ?  i_ZERO_FLAG ? (c_PC_OUT  | c_MAR_IN) : 0 :
            r_T_CYCLE == 'h3 ?  i_ZERO_FLAG ? (c_PC_INC | c_RAM_OUT | c_JUMP) : 0 :
            c_CU_ADVANCE :
        (i_IR_DATA == 'hA0) ?    // JC; if(CARRY_FLAG) PC = IMM4
            r_T_CYCLE == 'h2 ?  i_CARRY_FLAG ? (c_PC_OUT  | c_MAR_IN) : c_PC_INC | c_CU_ADVANCE :
            r_T_CYCLE == 'h3 ?  i_CARRY_FLAG ? (c_PC_INC | c_RAM_OUT | c_JUMP) : c_PC_INC | c_CU_ADVANCE :
            c_CU_ADVANCE :
        // Instruction 0x0B is unimplemented
        // Instruction 0x0C is unimplemented
        // Instruction 0x0D is unimplemented
        (i_IR_DATA == 'hE0) ?    // OUT; Display A
            r_T_CYCLE == 'h2 ?  c_A_OUT | c_OUT_IN :
            c_CU_ADVANCE :
        (i_IR_DATA == 'hF0) ?    // HLT; Halt the clock
            c_HALT :
            c_CU_ADVANCE;
endmodule
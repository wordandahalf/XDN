`timescale 1ps / 1ps
module ControlUnit
(
    input                               i_CLOCK,        // Clock input
    input   [(DATA_WIDTH / 2) - 1:0]    i_IR_DATA,      // Instruction register data, contans the opcode of the current instruction
    input                               i_ZERO_FLAG,
    input                               i_CARRY_FLAG,

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
        if(r_T_CYCLE == 'h6)
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
        (i_IR_DATA == 4'h01) ?    // LDA; A = RAM[IMM4]
            r_T_CYCLE == 'h2 ?  c_IR_OUT | c_MAR_IN     :
            r_T_CYCLE == 'h3 ?  c_RAM_OUT | c_A_IN      :
            0 :
        (i_IR_DATA == 4'h02) ?    // ADD; B = RAM[IMM4], A += B
            r_T_CYCLE == 'h2 ?  c_IR_OUT | c_MAR_IN     :
            r_T_CYCLE == 'h3 ?  c_RAM_OUT | c_B_IN      :
            r_T_CYCLE == 'h4 ?  c_ALU_OUT | c_A_IN | c_FLAGS_UPDATE :
            0 :
        (i_IR_DATA == 4'h03) ?    // SUB; B = RAM[IMM4], A -= B
            r_T_CYCLE == 'h2 ?  c_IR_OUT | c_MAR_IN     :
            r_T_CYCLE == 'h3 ?  c_RAM_OUT | c_B_IN      :
            r_T_CYCLE == 'h4 ?  c_ALU_OUT | c_A_IN | c_FLAGS_UPDATE | c_ALU_SUB :
            0 :
        (i_IR_DATA == 4'h04) ?    // LDI; A = IMM4
            r_T_CYCLE == 'h2 ?  c_IR_OUT | c_A_IN       :
            0 :
        (i_IR_DATA == 4'h05) ?    // ADDI; A += IMM4
            r_T_CYCLE == 'h2 ?  c_IR_OUT | c_B_IN       :
            r_T_CYCLE == 'h3 ?  c_ALU_OUT | c_A_IN | c_FLAGS_UPDATE :
            0 :
        (i_IR_DATA == 4'h06) ?    // SUBI; A -= IMM4
            r_T_CYCLE == 'h2 ?  c_IR_OUT | c_B_IN       :
            r_T_CYCLE == 'h3 ?  c_ALU_OUT | c_ALU_SUB | c_A_IN | c_FLAGS_UPDATE :
            0 :
        (i_IR_DATA == 4'h07) ?    // STA; RAM[IMM4] = A
            r_T_CYCLE == 'h2 ?  c_IR_OUT | c_MAR_IN     :
            r_T_CYCLE == 'h3 ?  c_A_OUT | c_RAM_IN      :
            0 :
        (i_IR_DATA == 4'h08) ?    // JMP; PC = IMM4
            r_T_CYCLE == 'h2 ?  c_IR_OUT | c_JUMP       :
            0 :
        (i_IR_DATA == 4'h09) ?    // JZ; if(ZERO_FLAG) PC = IMM4
            r_T_CYCLE == 'h2 ?  i_ZERO_FLAG ? (c_IR_OUT | c_JUMP) : 0 :
            0 :
        (i_IR_DATA == 4'h0A) ?    // JC; if(CARRY_FLAG) PC = IMM4
            r_T_CYCLE == 'h2 ?  i_CARRY_FLAG ? (c_IR_OUT | c_JUMP) : 0 :
            0 :
        // Instruction 0x0B is unimplemented
        // Instruction 0x0C is unimplemented
        // Instruction 0x0D is unimplemented
        (i_IR_DATA == 4'h0E) ?    // OUT; Display A
            r_T_CYCLE == 'h2 ?  c_A_OUT | c_OUT_IN :
            0 :
        (i_IR_DATA == 4'h0F) ?    // HLT; Halt the clock
            c_HALT :
            0;
endmodule
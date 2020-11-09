`timescale 1ns / 1ps
module XDN
(
    input   i_SYS_CLOCK,

    output  i_LED_0,

    input   i_BTN_0,
    input   i_BTN_1,
    input   i_BTN_2,
    input   i_BTN_3,
    input   i_BTN_4,

    output  o_SEG_A,
    output  o_SEG_B,
    output  o_SEG_C,
    output  o_SEG_D,
    output  o_SEG_E,
    output  o_SEG_F,
    output  o_SEG_G,
    output  o_SEG_DP,

    output  o_SEL_0,
    output  o_SEL_1,
    output  o_SEL_2,
    output  o_SEL_3,
    output  o_SEL_4,
    output  o_SEL_5
);

    parameter   DATA_WIDTH = 8;

    // CPU-wide connections.
    wire    [DATA_WIDTH - 1:0]      BUS;
    wire                            CLEAR_n;
    wire                            CLEAR;

    // Clock module
    wire    CLOCK_HALT;
    wire    CLOCK_STEP_TOGGLE;
    wire    CLOCK_STEP;

    wire    CLOCK;
    wire    CLOCK_n;

    Clock clock_module
    (
        i_SYS_CLOCK,
        CLOCK_HALT,
        CLOCK_STEP_TOGGLE,
        CLOCK_STEP,

        CLOCK,
        CLOCK_n
    );

    // Output module
    wire OUT_READ_BUS;

    Output output_module
    (
        i_SYS_CLOCK,
        BUS,
        OUT_READ_BUS,
        CLEAR_n,

        o_SEG_A,
        o_SEG_B,
        o_SEG_C,
        o_SEG_D,
        o_SEG_E,
        o_SEG_F,
        o_SEG_G,
        o_SEG_DP,

        o_SEL_0,
        o_SEL_1,
        o_SEL_2,
        o_SEL_3,
        o_SEL_4,
        o_SEL_5
    );

    wire    PC_COUNT_ENABLE;
    wire    PC_JUMP_n;
    wire    PC_WRITE_BUS;

    ProgramCounter #(DATA_WIDTH) program_counter
    (
        CLOCK,
        BUS,
        PC_COUNT_ENABLE,
        CLEAR_n,
        PC_JUMP_n,
        PC_WRITE_BUS
    );

    wire    A_READ_BUS_n;
    wire    A_WRITE_BUS_n;

    wire    [DATA_WIDTH - 1:0]  A_DATA;

    Register #(DATA_WIDTH) a_register
    (
        CLOCK,
        BUS,
        CLEAR,
        A_READ_BUS_n,
        A_WRITE_BUS_n,

        A_DATA
    );

    wire    B_READ_BUS_n;
    wire    B_WRITE_BUS_n;

    wire    [DATA_WIDTH - 1:0] B_DATA;

    Register #(DATA_WIDTH) b_register
    (
        CLOCK,
        BUS,
        CLEAR,
        B_READ_BUS_n,
        B_WRITE_BUS_n,

        B_DATA
    );

    wire    IR_READ_BUS_n;
    wire    IR_WRITE_BUS_n;

    wire    [DATA_WIDTH - 1:0] IR_DATA;

    InstructionRegister #(DATA_WIDTH) instruction_register
    (
        CLOCK,
        BUS,
        CLEAR,
        IR_READ_BUS_n,
        IR_WRITE_BUS_n,

        IR_DATA
    );

    begin
        assign CLEAR_n              = 1;
        assign CLEAR                = 0;
    
        // The LED is active low, so use the inverted clock signal to drive it.
        assign i_LED_0              = CLOCK_n;
        
        assign CLOCK_STEP_TOGGLE    = i_BTN_0;
        assign CLOCK_STEP           = i_BTN_1;
        
        assign PC_COUNT_ENABLE      = 1;
        assign PC_WRITE_BUS         = i_BTN_2;
        assign PC_JUMP_n            = 1;
        
        assign OUT_READ_BUS         = 1;

        assign A_READ_BUS_n         = i_BTN_3;
        assign A_WRITE_BUS_n        = i_BTN_4;

        assign B_READ_BUS_n         = 1;
        assign B_WRITE_BUS_n        = 1;

        assign IR_READ_BUS_n        = 1;
        assign IR_WRITE_BUS_n       = 1;
    end
endmodule

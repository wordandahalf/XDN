`timescale 1ns / 1ps
module XDN
(
    input   i_SYS_CLOCK,

    output  o_LED_0,
    output  o_LED_1,
    output  o_LED_2,
    output  o_LED_3,

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

    `include "src/ControlSignals.v"

    parameter   CLOCK_DIVIDER = 'h7FFFF;
    parameter   DATA_WIDTH = 8;
    parameter   ADDRESS_WIDTH = 4;
    parameter   RAM_LENGTH = 16;
    
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

    Clock #(CLOCK_DIVIDER) clock_module
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

    Output #(DATA_WIDTH) output_module
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

    // Program counter
    wire    PC_COUNT_ENABLE;
    wire    PC_JUMP;
    wire    PC_WRITE_BUS;

    ProgramCounter #(DATA_WIDTH, ADDRESS_WIDTH) program_counter
    (
        CLOCK,
        BUS,
        PC_COUNT_ENABLE,
        CLEAR_n,
        PC_JUMP,
        PC_WRITE_BUS
    );

    // A register
    wire    A_READ_BUS;
    wire    A_WRITE_BUS;

    wire    [DATA_WIDTH - 1:0]  A_DATA;

    Register #(DATA_WIDTH) a_register
    (
        CLOCK,
        BUS,
        CLEAR,
        A_READ_BUS,
        A_WRITE_BUS,

        A_DATA
    );

    // B register
    wire    B_READ_BUS;
    wire    B_WRITE_BUS;

    wire    [DATA_WIDTH - 1:0] B_DATA;

    Register #(DATA_WIDTH) b_register
    (
        CLOCK,
        BUS,
        CLEAR,
        B_READ_BUS,
        B_WRITE_BUS,

        B_DATA
    );

    // Instruction register
    wire    IR_READ_BUS;
    wire    IR_WRITE_BUS;

    wire    [(DATA_WIDTH / 2) - 1:0] IR_DATA;

    InstructionRegister #(DATA_WIDTH) instruction_register
    (
        CLOCK,
        BUS,
        CLEAR,
        IR_READ_BUS,
        IR_WRITE_BUS,

        IR_DATA
    );

    // ALU
    wire    ALU_WRITE_BUS;
    wire    ALU_SUBTRACT;

    wire    FLAGS_UPDATE;
    wire    ZERO_FLAG;
    wire    CARRY_FLAG;

    ALU #(DATA_WIDTH) alu
    (
        A_DATA,
        B_DATA,
        ALU_WRITE_BUS,
        ALU_SUBTRACT,
        BUS,

        CLOCK,
        CLEAR,
        FLAGS_UPDATE,

        ZERO_FLAG,
        CARRY_FLAG
    );

    wire    MAR_READ_BUS;
    wire    [ADDRESS_WIDTH - 1:0] MAR_DATA;

    MAR #(ADDRESS_WIDTH) mar
    (
        CLOCK,
        BUS[ADDRESS_WIDTH - 1:0],
        CLEAR,
        MAR_READ_BUS,
        MAR_DATA
    );

    wire    RAM_READ_BUS;
    wire    RAM_WRITE_BUS;

    RAM #(DATA_WIDTH, ADDRESS_WIDTH, RAM_LENGTH) ram
    (
        CLOCK,
        BUS,
        MAR_DATA,
        RAM_READ_BUS,
        RAM_WRITE_BUS
    );

    wire    [CONTROL_WIDTH - 1:0]   CONTROL_SIGNALS;

    ControlUnit #(DATA_WIDTH) cu
    (
        CLOCK,
        IR_DATA,
        ZERO_FLAG,
        CARRY_FLAG,

        CLEAR,
        CLEAR_n,
        CONTROL_SIGNALS
    );

    begin
        assign o_LED_0              = CLOCK;
        assign o_LED_1              = CLOCK_HALT;
        assign o_LED_2              = PC_JUMP;
        assign o_LED_3              = RAM_WRITE_BUS;
        
        assign CLOCK_STEP_TOGGLE    = i_BTN_0;
        assign CLOCK_STEP           = i_BTN_1;
        
        assign CLOCK_HALT           = CONTROL_SIGNALS[HALT_INDEX];
        assign MAR_READ_BUS         = CONTROL_SIGNALS[MAR_IN_INDEX];
        assign RAM_READ_BUS         = CONTROL_SIGNALS[RAM_IN_INDEX];
        assign RAM_WRITE_BUS        = CONTROL_SIGNALS[RAM_OUT_INDEX];
        assign IR_READ_BUS          = CONTROL_SIGNALS[IR_IN_INDEX];
        assign IR_WRITE_BUS         = CONTROL_SIGNALS[IR_OUT_INDEX];
        assign A_READ_BUS           = CONTROL_SIGNALS[A_IN_INDEX];
        assign A_WRITE_BUS          = CONTROL_SIGNALS[A_OUT_INDEX];
        assign ALU_WRITE_BUS        = CONTROL_SIGNALS[ALU_OUT_INDEX];
        assign ALU_SUBTRACT         = CONTROL_SIGNALS[ALU_SUB_INDEX];
        assign FLAGS_UPDATE         = CONTROL_SIGNALS[FLAGS_UPDATE_INDEX];
        assign B_READ_BUS           = CONTROL_SIGNALS[B_IN_INDEX];
        assign B_WRITE_BUS          = 0;
        assign OUT_READ_BUS         = CONTROL_SIGNALS[OUT_IN_INDEX];
        assign PC_COUNT_ENABLE      = CONTROL_SIGNALS[PC_INC_INDEX];
        assign PC_WRITE_BUS         = CONTROL_SIGNALS[PC_OUT_INDEX];
        assign PC_JUMP              = CONTROL_SIGNALS[JUMP_INDEX];
    end
endmodule

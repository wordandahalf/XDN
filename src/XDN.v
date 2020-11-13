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

    Clock #(32'h7FFFFF) clock_module
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
    wire    PC_JUMP_n;
    wire    PC_WRITE_BUS_n;

    ProgramCounter #(DATA_WIDTH) program_counter
    (
        CLOCK,
        BUS,
        PC_COUNT_ENABLE,
        CLEAR_n,
        PC_JUMP_n,
        PC_WRITE_BUS_n
    );

    // A register
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

    // B register
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

    // Instruction register
    wire    IR_READ_BUS_n;
    wire    IR_WRITE_BUS_n;

    wire    [(DATA_WIDTH / 2) - 1:0] IR_DATA;

    InstructionRegister #(DATA_WIDTH) instruction_register
    (
        CLOCK,
        BUS,
        CLEAR,
        IR_READ_BUS_n,
        IR_WRITE_BUS_n,

        IR_DATA
    );

    // ALU
    wire    ALU_WRITE_BUS_n;
    wire    ALU_SUBTRACT;

    wire    FLAGS_UPDATE_n;
    wire    ZERO_FLAG;
    wire    CARRY_FLAG;

    ALU #(DATA_WIDTH) alu
    (
        A_DATA,
        B_DATA,
        ALU_WRITE_BUS_n,
        ALU_SUBTRACT,
        BUS,

        CLOCK,
        CLEAR,
        FLAGS_UPDATE_n,

        ZERO_FLAG,
        CARRY_FLAG
    );

    wire    MAR_READ_BUS_n;
    wire    [ADDRESS_WIDTH - 1:0] MAR_DATA;

    MAR #(ADDRESS_WIDTH) mar
    (
        CLOCK,
        BUS[ADDRESS_WIDTH - 1:0],
        CLEAR,
        MAR_READ_BUS_n,
        MAR_DATA
    );

    wire    RAM_READ_BUS;
    wire    RAM_WRITE_BUS_n;

    RAM #(DATA_WIDTH, ADDRESS_WIDTH, RAM_LENGTH) ram
    (
        CLOCK,
        BUS,
        MAR_DATA,
        RAM_READ_BUS,
        RAM_WRITE_BUS_n
    );

    // Keeps track of the simple FSM:
    // When 0, the PC writes its value to the bus, which is read by the A and B registers
    // When 1, the ALU adds the two registers and writes the result to the bus, which is read by the RAM module and written to address 0x0
    // When 2, the RAM module outputs the value of address 0x0 to the bus, which is read by the output register
    reg [1:0]   r_STATE = 0;

    begin
        always @(posedge CLOCK)
        begin
            if(r_STATE == 'h2)
                r_STATE = 0;
            else
                r_STATE = r_STATE + 1'b1;
        end

        assign CLEAR_n              = 1;
        assign CLEAR                = 0;
    
        assign o_LED_0              = CLOCK;
        assign o_LED_1              = r_STATE[1];
        assign o_LED_2              = r_STATE[0];
        assign o_LED_3              = !RAM_WRITE_BUS_n;
        
        assign CLOCK_STEP_TOGGLE    = i_BTN_0;
        assign CLOCK_STEP           = i_BTN_1;
        
        assign PC_COUNT_ENABLE      = r_STATE == 2; // High when state is two
        assign PC_WRITE_BUS_n       = r_STATE != 0; // Low when state is zero 
        assign PC_JUMP_n            = 1;
        
        assign OUT_READ_BUS         = r_STATE == 2; // High when state is two

        assign A_READ_BUS_n         = r_STATE != 0; // Low when state is zero
        assign A_WRITE_BUS_n        = 1;

        assign B_READ_BUS_n         = r_STATE != 0; // Low when state is zero
        assign B_WRITE_BUS_n        = 1;

        assign IR_READ_BUS_n        = 1;
        assign IR_WRITE_BUS_n       = 1;

        assign ALU_WRITE_BUS_n      = r_STATE != 1; // Low when state is two
        assign ALU_SUBTRACT         = !i_BTN_3; // Buttons are high when open.

        assign FLAGS_UPDATE_n       = r_STATE != 1; // Low when state is one

        assign MAR_READ_BUS_n       = 1;
        assign RAM_READ_BUS         = r_STATE == 1; // High when state is one
        assign RAM_WRITE_BUS_n      = r_STATE != 2; // Low when state is two
    end
endmodule

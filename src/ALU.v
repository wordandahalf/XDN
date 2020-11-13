`timescale 1ns / 1ps
module ALU
(
    // ALU
    input   [DATA_WIDTH - 1:0]  i_A_DATA,       // Contents of the A register
    input   [DATA_WIDTH - 1:0]  i_B_DATA,       // Contents of the B register
    input                       i_WRITE_BUS_n,  // Active-low signal to write ALU result to the variable-length bus
    input                       i_SUB,          // Signal that indicates to subtract B from A (with two's complement)
    output   [DATA_WIDTH - 1:0] o_BUS,          // Variable-length CPU data bus

    // Flags register
    input                       i_CLOCK,            // Clock input
    input                       i_CLEAR,            // Async clear signal
    input                       i_UPDATE_FLAGS_n,   // Active-low signal to update the flags from the current ALU result.

    output                      o_ZERO_FLAG,        // The zero flag. Set when the result of the ALU is exactly equal to zero.
    output                      o_CARRY_FLAG        // The carry flag. Set when there is a carry into/borrow from bit DATA_WIDTH.
);

    parameter   DATA_WIDTH = 8;

    // The most significant bit is the value of the carry flag
    reg [DATA_WIDTH:0]  r_RESULT    = 0;

    // The flags register.
    // The zero flag is bit 1, the carry flag bit 0.
    reg [1:0]           r_FLAGS     = 2'b10;

    // Perform the arithmetic
    always @(i_A_DATA, i_B_DATA, i_SUB)
    begin
        if(i_SUB)
            r_RESULT <= i_A_DATA - i_B_DATA;
        else
            r_RESULT <= i_A_DATA + i_B_DATA;
    end

    // Clear or update the flags
    always @(posedge i_CLOCK, posedge i_CLEAR)
    begin
        // Clear the flags
        if(i_CLEAR)
            r_FLAGS <= 0;
        else begin
            // Update the flags
            if(!i_UPDATE_FLAGS_n) begin
                // Update the ZF
                r_FLAGS[1:1] <= (r_RESULT == 0) ? 1'b1 : 1'b0;

                // Update the CF
                r_FLAGS[0:0] <= r_RESULT[DATA_WIDTH:DATA_WIDTH];
            end
        end
    end

    assign o_BUS = (!i_WRITE_BUS_n) ? r_RESULT[DATA_WIDTH - 1:0] : 'bz; 
    assign o_ZERO_FLAG = r_FLAGS[1:1];
    assign o_CARRY_FLAG = r_FLAGS[0:0];
endmodule
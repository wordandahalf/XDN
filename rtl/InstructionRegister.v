`timescale 1ps / 1ps
module InstructionRegister
(
    input                           i_CLOCK,        // Clock input
    inout   [DATA_WIDTH - 1:0]      BUS,            // Main, variable-width CPU data bus
    input                           i_CLEAR,        // Async clear
    input                           i_READ_BUS,     // Active-low signal to read the bus
    input                           i_WRITE_BUS,    // Active-low signal to write to the bus

    output  [ADDRESS_WIDTH - 1:0] o_DATA            // Higher nibble output for CU instruction decoding
);

    parameter DATA_WIDTH = 8;
    parameter ADDRESS_WIDTH = 4;

    reg     [DATA_WIDTH - 1:0]      r_VALUE = 0;

    always @(posedge i_CLOCK, posedge i_CLEAR)
    begin
        if (i_CLEAR) begin
            r_VALUE <= 0;
        end
        else begin
            if(i_READ_BUS)
                r_VALUE <= BUS;
        end
    end

    assign o_DATA                       = r_VALUE[(DATA_WIDTH - 1):ADDRESS_WIDTH];
    assign BUS[ADDRESS_WIDTH - 1:0]     = (i_WRITE_BUS) ? r_VALUE[ADDRESS_WIDTH - 1:0] : {ADDRESS_WIDTH {1'bz}};
endmodule
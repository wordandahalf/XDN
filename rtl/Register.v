`timescale 1ps / 1ps
module Register
(
    input                           i_CLOCK,        // Clock input
    inout   [DATA_WIDTH - 1:0]      BUS,            // Main CPU data bus
    input                           i_CLEAR,        // Async clear
    input                           i_READ_BUS,     // Indicates to read the value from the bus
    input                           i_WRITE_BUS,    // Indicates to write the value to the bus

    output [DATA_WIDTH - 1:0]       o_DATA          // Output bus for ALU
);

    parameter DATA_WIDTH = 8;

    reg     [DATA_WIDTH - 1:0]      r_VALUE = 0;

    always @(posedge i_CLOCK, posedge i_CLEAR)
    begin
        if (i_CLEAR)
            r_VALUE <= 0;
        else if(i_READ_BUS)
            r_VALUE <= BUS;
    end

    assign o_DATA   = r_VALUE;
    assign BUS      = (i_WRITE_BUS) ? r_VALUE : {DATA_WIDTH {1'bz}};
endmodule
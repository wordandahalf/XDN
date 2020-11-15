`timescale 1ns / 1ps
module ProgramCounter
(
    input                           i_CLOCK,        // Clock input
    inout	[DATA_WIDTH - 1:0]      BUS,            // Main, variable-width CPU bus
    input                           i_COUNT_ENABLE, // Increments counter on rising edge of clock
    input                           i_CLEAR_n,      // Async clear
    input                           i_JUMP,       // Active-low jump signal, loads 32-bit value from bus into counter
    input                           i_OUTPUT      // Active-low output signal, pushes the 32-bit counter value onto the bus
);

    parameter   DATA_WIDTH  = 8; 
    parameter   ADDRESS_WIDTH = 4;

    reg	[ADDRESS_WIDTH - 1:0]  r_COUNTER   = 0;

    always @(posedge i_CLOCK, negedge i_CLEAR_n)
    begin
        // If i_CLEAR_n is low, reset
        if (!i_CLEAR_n)
            r_COUNTER <= 0;
        // Else, if i_JUMP is low, load from bus
        else if (i_JUMP)
            r_COUNTER <= BUS;
        // Else if i_COUNT_ENABLE, increment the counter
        else if (i_COUNT_ENABLE) begin
        //	if &r_COUNTER is full, it will overflow
            if (&r_COUNTER)
                r_COUNTER <= 0;
            else
                r_COUNTER <= r_COUNTER + 1'b1;
        end
    end

    assign BUS[ADDRESS_WIDTH - 1:0] = (i_OUTPUT) ? r_COUNTER : 'bz;
endmodule

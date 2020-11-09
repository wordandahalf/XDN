`timescale 1ns / 1ps
module Divider
(
    input   i_SYS_CLOCK,
    output  o_CLOCK
);
 
    reg         r_CLOCK_SIGNAL	= 0;
 
    reg [31:0]  r_DIVIDER       = 32'b0;
    parameter   DIVISOR         = 32'h2;

    always @(posedge i_SYS_CLOCK)
    begin
        r_DIVIDER = r_DIVIDER + 32'b1;
        
        // Reset the counter when it is full -- Verilog doesn't allow registers to overflow.
        if (r_DIVIDER > (DIVISOR - 32'b1))
            r_DIVIDER = 32'b0;
            
        if (r_DIVIDER < (DIVISOR / 2))
            r_CLOCK_SIGNAL = 1'b0;
        else
            r_CLOCK_SIGNAL = 1'b1;
    end

    assign  o_CLOCK = r_CLOCK_SIGNAL;
endmodule

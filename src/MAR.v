module MAR
(
    input                           i_CLOCK,    // Clock input
    input   [ADDRESS_WIDTH - 1:0]   i_BUS,      // Main CPU bus
    input                           i_CLEAR,    // Async clear
    input                           i_READ_BUS, // Indicates to read the value from the bus
    
    output  [ADDRESS_WIDTH - 1:0]   o_DATA
);

    parameter ADDRESS_WIDTH = 4;

    reg [ADDRESS_WIDTH - 1:0] r_VALUE = 0;

    always @(posedge i_CLOCK, posedge i_CLEAR)
    begin
        if(i_CLEAR)
            r_VALUE <= 0;
        else if(i_READ_BUS)
            r_VALUE <= i_BUS;
    end

    assign o_DATA = r_VALUE;
endmodule
`timescale 1ns / 1ps
module RAM
(
    input                           i_CLOCK,
    inout   [DATA_WIDTH - 1:0]      BUS,
    input   [ADDRESS_WIDTH - 1:0]   i_MAR_DATA,

    input                           i_READ_BUS,
    input                           i_WRITE_BUS
);

    parameter   DATA_WIDTH      = 8;
    parameter   ADDRESS_WIDTH   = $clog2(RAM_LENGTH);
    parameter   RAM_LENGTH      = 16;

    localparam  RAM_FILE        = "data/ram.hex";

    reg [DATA_WIDTH - 1:0]  r_VALUE = 0;
    reg [DATA_WIDTH - 1:0]  r_RAM   [0:RAM_LENGTH - 1];

    initial
    begin
        $readmemh(RAM_FILE, r_RAM);
    end

    always @(posedge i_CLOCK)
    begin
        if(i_READ_BUS)
            r_RAM[i_MAR_DATA] = BUS;
    end

    assign BUS = (i_WRITE_BUS) ? r_RAM[i_MAR_DATA] : 'bz;
endmodule
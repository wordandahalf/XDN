`timescale 1ps / 1ps
module RAM
(
    input                           i_CLOCK,
    inout   [DATA_WIDTH - 1:0]      BUS,
    input   [DATA_WIDTH - 1:0]      i_MAR_DATA,

    input                           i_READ_BUS,
    input                           i_WRITE_BUS
);

    parameter   DATA_WIDTH      = 8;
    parameter   RAM_LENGTH      = 256;

    localparam  RAM_FILE         = "data/ram.hex";

    reg [DATA_WIDTH - 1:0]  r_RAM   [0:255];

    initial
    begin
        $readmemh(RAM_FILE, r_RAM);
    end

    always @(posedge i_CLOCK)
    begin
        if(i_READ_BUS)
            r_RAM[i_MAR_DATA] <= BUS;
    end

    assign BUS = (i_WRITE_BUS) ? r_RAM[i_MAR_DATA] : {DATA_WIDTH {1'bz}};
endmodule
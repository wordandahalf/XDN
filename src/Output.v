`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:45 10/30/2020 
// Design Name: 
// Module Name:    Output 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Output
(
    input			i_SYS_CLOCK,		// The raw system clock input from the on-board crystal 
    input [31:0]	i_BUS,				// The 32-bit bus of the CPU
    input			i_READ_BUS,			//	Indicates to the module to read bits 0-23 of the bus into r_VALUE.
    input			i_CLEAR_n,			// Active low clear signal, sets r_NUMBER to 0.
    
    output			o_SEG_A,
    output			o_SEG_B,
    output			o_SEG_C,
    output			o_SEG_D,
    output			o_SEG_E,
    output			o_SEG_F,
    output			o_SEG_G,
    output			o_SEG_DP,
    
    output			o_SEL_0,
    output			o_SEL_1,
    output			o_SEL_2,
    output			o_SEL_3,
    output			o_SEL_4,
    output			o_SEL_5
);

    // Output wire for clock divider.
    wire			w_CLOCK;
    
    // The 24-bit value to display on the 6 seven-segment displays.
    reg	[23:0]	    r_VALUE				= 24'b0;

    // A bitfield that keeps track of the seven-segment currently being driven.
    reg	[5:0]		r_DIGIT_SELECT		= 6'b1;
    // The nybble that is to be displayed on the current seven-segment display.
    reg	[3:0]		r_DIGIT_VALUE		= 4'b0;
    // A bitfield storing the values of each individual segment of the currently driven seven-segnment display.
    reg	[6:0]		r_SEGMENT_VALUES	= 7'b0;

    parameter		DIVISOR				= 32'hFFFF;

    // Clock divider, divides the FPGA's 50MHz signal by 0x7FFF.
    Divider #(DIVISOR) clock_divider
    (
        i_SYS_CLOCK,
        w_CLOCK
    );
    
    // Clears r_VALUE when i_CLEAR_n goes low and
    // reads the bits 0-24 of i_BUS into r_VALUE when i_READ_BUS goes high.
    // i_CLEAR_n is async, i_READ_BUS is sync.
    always @(posedge w_CLOCK, negedge i_CLEAR_n)
    begin
        if (!i_CLEAR_n)
            r_VALUE <= 24'b0;
        else if(i_READ_BUS)
            r_VALUE <= i_BUS[23:0];
    end
    
    // Updates r_DIGIT_SELECT every (divided) clock cycle.
    always @(posedge w_CLOCK)
    begin
        if (r_DIGIT_SELECT == 6'b100000)
            r_DIGIT_SELECT <= 6'b1;
        else
            r_DIGIT_SELECT <= r_DIGIT_SELECT << 1;
    end
    
    // Updates r_DIGIT_VALUE and r_SEGMENT_VALUES when their dependencies are updated.
    always @(r_DIGIT_SELECT, r_VALUE, r_DIGIT_VALUE) 
    begin
        case (r_DIGIT_SELECT)
            6'b000001 : r_DIGIT_VALUE <= r_VALUE[3:0];
            6'b000010 : r_DIGIT_VALUE <= r_VALUE[7:4];
            6'b000100 : r_DIGIT_VALUE <= r_VALUE[11:8];
            6'b001000 : r_DIGIT_VALUE <= r_VALUE[15:12];
            6'b010000 : r_DIGIT_VALUE <= r_VALUE[19:16];
            6'b100000 : r_DIGIT_VALUE <= r_VALUE[23:20];
            default   : r_DIGIT_VALUE <= r_VALUE[3:0];
        endcase
    
        case (r_DIGIT_VALUE)
          4'b0000 : r_SEGMENT_VALUES <= 7'h7E;
        4'b0001 : r_SEGMENT_VALUES <= 7'h30;
        4'b0010 : r_SEGMENT_VALUES <= 7'h6D;
        4'b0011 : r_SEGMENT_VALUES <= 7'h79;
        4'b0100 : r_SEGMENT_VALUES <= 7'h33;          
        4'b0101 : r_SEGMENT_VALUES <= 7'h5B;
        4'b0110 : r_SEGMENT_VALUES <= 7'h5F;
        4'b0111 : r_SEGMENT_VALUES <= 7'h70;
        4'b1000 : r_SEGMENT_VALUES <= 7'h7F;
        4'b1001 : r_SEGMENT_VALUES <= 7'h7B;
        4'b1010 : r_SEGMENT_VALUES <= 7'h77;
        4'b1011 : r_SEGMENT_VALUES <= 7'h1F;
        4'b1100 : r_SEGMENT_VALUES <= 7'h4E;
        4'b1101 : r_SEGMENT_VALUES <= 7'h3D;
        4'b1110 : r_SEGMENT_VALUES <= 7'h4F;
        4'b1111 : r_SEGMENT_VALUES <= 7'h47;
          default : r_SEGMENT_VALUES <= 7'h7E;
        endcase
    end
    
    assign o_SEL_0		= !r_DIGIT_SELECT[0];
    assign o_SEL_1		= !r_DIGIT_SELECT[1];
    assign o_SEL_2		= !r_DIGIT_SELECT[2];
    assign o_SEL_3		= !r_DIGIT_SELECT[3];
    assign o_SEL_4		= !r_DIGIT_SELECT[4];
    assign o_SEL_5		= !r_DIGIT_SELECT[5];

    assign o_SEG_DP 	= 1;
    assign o_SEG_A 	    = !r_SEGMENT_VALUES[6];
    assign o_SEG_B		= !r_SEGMENT_VALUES[5];
    assign o_SEG_C		= !r_SEGMENT_VALUES[4];
    assign o_SEG_D		= !r_SEGMENT_VALUES[3];
    assign o_SEG_E		= !r_SEGMENT_VALUES[2];
    assign o_SEG_F		= !r_SEGMENT_VALUES[1];
    assign o_SEG_G		= !r_SEGMENT_VALUES[0];
endmodule

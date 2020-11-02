`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:53:27 10/31/2020 
// Design Name: 
// Module Name:    Debouncer 
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
module Debouncer
(
    input 		i_SYS_CLOCK,
    input 		i_BTN,
	output 		o_BTN
);

	parameter	p_DIVIDER		= 5;	// Divider for the clock

endmodule

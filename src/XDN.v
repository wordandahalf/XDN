`timescale 1ns / 1ps
module XDN
(
	input			i_SYS_CLOCK,
	
	output		    i_LED_0,
	
	input			i_BTN_0,
	input			i_BTN_1,
	input			i_BTN_2,
	input			i_BTN_3,
	
	output		    o_SEG_A,
	output		    o_SEG_B,
	output		    o_SEG_C,
	output		    o_SEG_D,
	output		    o_SEG_E,
	output		    o_SEG_F,
	output		    o_SEG_G,
	output		    o_SEG_DP,
	
	output		    o_SEL_0,
	output		    o_SEL_1,
	output		    o_SEL_2,
	output		    o_SEL_3,
	output		    o_SEL_4,
	output		    o_SEL_5
);

// CPU-wide connections.
wire	[31:0]	    BUS;
wire				i_CLEAR_n;

// Clock module
wire				i_HALT;
wire				i_STEP_TOGGLE;
wire				i_STEP_CLOCK;

wire				o_CLOCK;
wire				o_CLOCK_n;

// Test value for clock and output modules
reg	[23:0]	i_NUMBER = 24'b0;

Clock clock_module
(
	i_SYS_CLOCK,
	i_HALT,
	i_STEP_TOGGLE,
	i_STEP_CLOCK,
	
	o_CLOCK,
	o_CLOCK_n
);

// Output module
wire				i_READ_BUS;

Output output_module
(
	i_SYS_CLOCK,
	BUS,
	i_READ_BUS,
	i_CLEAR_n,
	
	o_SEG_A,
	o_SEG_B,
	o_SEG_C,
	o_SEG_D,
	o_SEG_E,
	o_SEG_F,
	o_SEG_G,
	o_SEG_DP,
	
	o_SEL_0,
	o_SEL_1,
	o_SEL_2,
	o_SEL_3,
	o_SEL_4,
	o_SEL_5
);

wire				i_COUNT_ENABLE;
wire				i_JUMP_n;
wire				i_OUTPUT_n;

ProgramCounter program_counter
(
	o_CLOCK,
	BUS,
	i_COUNT_ENABLE,
	i_CLEAR_n,
	i_JUMP_n,
	i_OUTPUT_n
);

begin
	// The LED is active low, so use the inverted clock signal to drive it.
	assign i_LED_0 			= o_CLOCK_n;
	
	// Clock module drivers.
	assign i_STEP_TOGGLE		= i_BTN_0;
	assign i_STEP_CLOCK 		= i_BTN_1;
	
	assign i_COUNT_ENABLE 	= i_BTN_2;
	assign i_CLEAR_n 			= 1;
	assign i_JUMP_n 			= 1;
	
	assign i_READ_BUS			= 1;
end

endmodule

`timescale 1ns / 1ps
module ProgramCounter
(
	input				i_CLOCK,				// Clock input
	inout	[31:0]	BUS,					// 32-bit CPU bus
	input				i_COUNT_ENABLE,	// Increments counter on rising edge of clock
	input				i_CLEAR_n,			// Async clear
	input				i_JUMP_n,			// Active-low jump signal, loads 32-bit value from bus into counter
	input				i_OUTPUT_n			// Active-low output signal, pushes the 32-bit counter value onto the bus
);

	reg	[31:0]	r_COUNTER	= 32'b0;

	always @(posedge i_CLOCK, negedge i_CLEAR_n)
	begin
		// If i_CLEAR_n is low, reset
		if (!i_CLEAR_n)
			r_COUNTER <= 32'b0;
		// Else, if i_JUMP_n is low, load from bus
		else if (!i_JUMP_n)
			r_COUNTER <= BUS;
		// Else if i_COUNT_ENABLE, increment the counter
		else if (i_COUNT_ENABLE)
		begin
		//	if &r_COUNTER is full, it will overflow
			if (&r_COUNTER)
				r_COUNTER <= 32'b0;
			else
				r_COUNTER <= r_COUNTER + 32'b1;
		end
	end

	assign BUS = !i_OUTPUT_n ? r_COUNTER : 1'b0;
endmodule
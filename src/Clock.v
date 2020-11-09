`timescale 1ns / 1ps
module Clock
(
    input       i_SYS_CLOCK,    // The system clock input from the on-board crystal
    input       i_HALT,	        // Halt signal, holds o_CLOCK low and o_CLOCK_n high
    input       i_STEP_TOGGLE,  // Toggles manual stepping
    input       i_STEP_CLOCK,   // Drives o_CLOCK iff manual stepping has been enabled

    output      o_CLOCK,
    output      o_CLOCK_n
);  

    wire        w_CLOCK;

    reg         r_CLOCK_SIGNAL	= 0;
    reg         r_MANUAL_STEP	= 0;	// 1-bit register (a Boolean, essentially) for keeping track of whether manual stepping is enabled 

    parameter 	DIVISOR			= 32'hFFFFFF;   // Default divisor for the system clock
    
    Divider #(DIVISOR) clock_divider
    (
        i_SYS_CLOCK,
        w_CLOCK
    );

    // Toggle r_MANUAL_STEP when i_STEP_TOGGLE goes high
    always @(posedge i_STEP_TOGGLE)
    begin
        r_MANUAL_STEP = !r_MANUAL_STEP;
    end

    // Logic for the clock module
    always @(posedge i_SYS_CLOCK)
    begin
        // i_HALT stops the clock
        if (i_HALT)
            r_CLOCK_SIGNAL = 1'b0;
        else
        begin
            // If manual stepping is enabled, pass that signal through.
            if (r_MANUAL_STEP)
                r_CLOCK_SIGNAL = i_STEP_CLOCK;
            // Otherwise, pass the divided clock signal through.
            else
                r_CLOCK_SIGNAL = w_CLOCK;
        end
    end

    assign o_CLOCK				= r_CLOCK_SIGNAL;
    assign o_CLOCK_n			= !o_CLOCK;
endmodule

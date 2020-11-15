`timescale 1ps / 1ps

module XDN_TB;
	// Inputs
	reg i_SYS_CLOCK;
	reg i_BTN_0;
	reg i_BTN_1;
	reg i_BTN_2;
	reg i_BTN_3;
	reg i_BTN_4;

	// Outputs
	wire o_LED_0;
	wire o_LED_1;
	wire o_LED_2;
	wire o_LED_3;
    
	wire o_SEG_A;
	wire o_SEG_B;
	wire o_SEG_C;
	wire o_SEG_D;
	wire o_SEG_E;
	wire o_SEG_F;
	wire o_SEG_G;
	wire o_SEG_DP;
    
	wire o_SEL_0;
	wire o_SEL_1;
	wire o_SEL_2;
	wire o_SEL_3;
	wire o_SEL_4;
	wire o_SEL_5;

	// Instantiate the Unit Under Test (UUT)
	XDN #(32'hFF) uut (
		.i_SYS_CLOCK(i_SYS_CLOCK), 
        
		.o_LED_0(o_LED_0), 
		.o_LED_1(o_LED_1), 
		.o_LED_2(o_LED_2), 
		.o_LED_3(o_LED_3), 
        
		.i_BTN_0(i_BTN_0), 
		.i_BTN_1(i_BTN_1), 
		.i_BTN_2(i_BTN_2), 
		.i_BTN_3(i_BTN_3), 
		.i_BTN_4(i_BTN_4), 
        
		.o_SEG_A(o_SEG_A), 
		.o_SEG_B(o_SEG_B), 
		.o_SEG_C(o_SEG_C), 
		.o_SEG_D(o_SEG_D), 
		.o_SEG_E(o_SEG_E), 
		.o_SEG_F(o_SEG_F), 
		.o_SEG_G(o_SEG_G), 
		.o_SEG_DP(o_SEG_DP), 
        
		.o_SEL_0(o_SEL_0), 
		.o_SEL_1(o_SEL_1), 
		.o_SEL_2(o_SEL_2), 
		.o_SEL_3(o_SEL_3), 
		.o_SEL_4(o_SEL_4), 
		.o_SEL_5(o_SEL_5)
	);

    initial begin
        i_SYS_CLOCK = 0;
        forever begin
            #1;
            i_SYS_CLOCK = !i_SYS_CLOCK;
        end
    end

	initial begin
		i_BTN_0 = 0;
		i_BTN_1 = 0;
		i_BTN_2 = 0;
		i_BTN_3 = 0;
		i_BTN_4 = 0;
	end
endmodule


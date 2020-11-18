localparam CONTROL_WIDTH        = 17;

// Definition of signal indices in the control word
localparam  CU_ADVANCE_INDEX    = 'h10;
localparam  HALT_INDEX          = 'hF;
localparam  MAR_IN_INDEX        = 'hE;
localparam  RAM_IN_INDEX        = 'hD;
localparam  RAM_OUT_INDEX       = 'hC;
localparam  IR_IN_INDEX         = 'hB;
localparam  IR_OUT_INDEX        = 'hA;
localparam  A_IN_INDEX          = 'h9;
localparam  A_OUT_INDEX         = 'h8;
localparam  ALU_OUT_INDEX       = 'h7;
localparam  ALU_SUB_INDEX       = 'h6;
localparam  FLAGS_UPDATE_INDEX  = 'h5;
localparam  B_IN_INDEX          = 'h4;
localparam  OUT_IN_INDEX        = 'h3;
localparam  PC_INC_INDEX        = 'h2;
localparam  PC_OUT_INDEX        = 'h1;
localparam  JUMP_INDEX          = 'h0;

localparam [CONTROL_WIDTH - 1:0]    c_CU_ADVANCE    = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << CU_ADVANCE_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_HALT          = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << HALT_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_MAR_IN        = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << MAR_IN_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_RAM_IN        = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << RAM_IN_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_RAM_OUT       = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << RAM_OUT_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_IR_IN         = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << IR_IN_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_IR_OUT        = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << IR_OUT_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_A_IN          = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << A_IN_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_A_OUT         = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << A_OUT_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_ALU_OUT       = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << ALU_OUT_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_ALU_SUB       = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << ALU_SUB_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_FLAGS_UPDATE  = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << FLAGS_UPDATE_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_B_IN          = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << B_IN_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_OUT_IN        = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << OUT_IN_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_PC_INC        = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << PC_INC_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_PC_OUT        = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << PC_OUT_INDEX;
localparam [CONTROL_WIDTH - 1:0]    c_JUMP          = {{CONTROL_WIDTH - 1{1'b0}}, 1'b1} << JUMP_INDEX;
module Instruction_Fetch
(
	input clock,
	input reset,
	output [31:0] Instruction
	output [63:0] PC_Out
);

wire [63:0] PC_In;
  


Program_Counter PC
(
	.clock(clock),
	.reset(reset),
	.PC_In(PC_In),
	.PC_Out(PC_Out)
);


Instruction_Memory IM
(	
	.Inst_Address(PC_Out),
	.Instruction(Instruction)
);

Adder_64_bit Add
(
  	.a(PC_Out),
  	.b(64'd4),
	.result(PC_In)
);

endmodule 
			




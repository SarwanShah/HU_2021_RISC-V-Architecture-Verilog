module Instruction_Parser
(
	input [31:0] instruction;
	
	output reg [6:0] opcode;
	output reg [6:0] func7;
	
	output reg [4:0] rd;
	output reg [4:0] rs1;
	output reg [4:0] rs2;
	
	output reg [2:0] func3;
	
);

always @(*)
	begin
		opcode = instruction[6:0];
		func7 = instruction[31:25];
		rd = instruction[11:7];
		rs1 = instruction[19:15];
		rs2 = instruction[24:20];
		func3 = instruction[14:12];
	end

endmodule
	
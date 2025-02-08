module Instruction_Parser
(
  input [31:0] instruction,
	
  output reg [6:0] opcode,
  output reg [6:0] func7,
	
  output reg [4:0] rd,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
	
  output reg [2:0] func3
	
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



module registerFile
(
	input [4:0] rs1,
	input [4:0] rs2,
	input [4:0] rd,
	input [63:0] writeData,
	input regWrite,
	
	input clock,
	input reset,
	
	output reg [63:0] readData1,
	output reg [63:0] readData2
);

reg [63:0] Registers [31:0];  //an array of registers for storage wagera

initial 
	begin 
		Registers[0] = 0;
		Registers[1] = 1;
		Registers[2] = 2;
		Registers[3] = 3;
		Registers[4] = 4;
		Registers[5] = 5;
		Registers[6] = 6;
		Registers[7] = 7;
		Registers[8] = 8;
		Registers[9] = 9;
		Registers[10] = 10;
		Registers[11] = 11;
		Registers[12] = 12;
		Registers[13] = 13;
		Registers[14] = 14;
		Registers[15] = 15;
		Registers[16] = 16;
		Registers[17] = 17;
		Registers[18] = 18;
		Registers[19] = 19;
		Registers[20] = 20;
		Registers[21] = 21;
		Registers[22] = 22;
		Registers[23] = 23;
		Registers[24] = 24;
		Registers[25] = 25;
		Registers[26] = 26;
		Registers[27] = 27;
		Registers[28] = 28;
		Registers[29] = 29;
		Registers[30] = 30;
		Registers[31] = 31;
	end 
	
always @ (posedge clock)
	begin
		case (regWrite)
			1'b1:                               // if regWrite is HIGH, writeData to the register
              Registers[rd] <= writeData;
		endcase
	end
	
always @ (*)
	begin 
		case (reset)
			1'b1:
			begin
				readData1 = 0;
				readData2 = 0;
			end
				
			1'b0:
			begin
				readData1 <= Registers[rs1];
				readData2 <= Registers[rs2];
			end		
		endcase
	end
				

endmodule



module top
(
	input reg [31:0] instruction,
	output [63:0] readData1,
	output [63:0] readData2, 
	output [6:0] opcode,
	
	input regWrite,
	input clock,
	input reset
	
);

	wire [6:0] func7;
	wire [4:0] rd;
	wire [2:0] func3;	
	wire [4:0] rs1;
	wire [4:0] rs2;

	
	Instruction_Parser IP
	(
		.instruction(instruction),
		.opcode(opcode),
		.func7(func7),
		.func3(func3),
		.rd(rd),
		.rs1(rs1),
		.rs2(rs2)
	);
	
	
	registerFile RF
	(
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.reset(reset),
		.clock(clock),
		.writeData(writeData),
		.regWrite(regWrite),
		.readData1(readData1),
		.readData2(readData2)
	);


endmodule 
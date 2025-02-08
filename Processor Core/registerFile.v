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
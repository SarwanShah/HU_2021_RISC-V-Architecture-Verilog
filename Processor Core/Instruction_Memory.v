module Instruction_Memory
(
	input [61:0] Inst_Address,
	output reg [31:0] Instruction
);

reg [7:0] instructionsMem [15:0];  //an array of registers for storage wagera

initial 
	begin 
		instructionsMem[0] = 8'b10000011;
		instructionsMem[1] = 8'b00110100;
		instructionsMem[2] = 8'b00000101;
		instructionsMem[3] = 8'b00001111;
		instructionsMem[4] = 8'b10110011;
		instructionsMem[5] = 8'b10000100;
		instructionsMem[6] = 8'b10011010;
		instructionsMem[7] = 8'b00000000;
		instructionsMem[8] = 8'b10010011;
		instructionsMem[9] = 8'b10000100;
		instructionsMem[10] = 8'b00010100;
		instructionsMem[11] = 8'b00000000;
		instructionsMem[12] = 8'b00100011;
		instructionsMem[13] = 8'b00111000;
		instructionsMem[14] = 8'b10010101;
		instructionsMem[15] = 8'b00001110;		
	end
	
always @ (*)
	begin 
      if (Inst_Address <= 12) 
        begin
		Instruction = {instructionsMem[Inst_Address+3], instructionsMem[Inst_Address+2], instructionsMem[Inst_Address+1], instructionsMem[Inst_Address]};
        end
      else if (Inst_Address == 13) 
        begin
        Instruction = {instructionsMem[Inst_Address+2], instructionsMem[Inst_Address+1], instructionsMem[Inst_Address]};
        end
      else if (Inst_Address == 14)
        begin
        Instruction = {instructionsMem[Inst_Address+1], instructionsMem[Inst_Address]};
        end
      else 
        begin
          Instruction = instructionsMem[Inst_Address];
        end
	end

endmodule
				

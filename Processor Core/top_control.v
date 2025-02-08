module Control_Unit
(
	input [6:0] Opcode,
	output reg Branch,
	output reg MemRead,
	output reg MemtoReg,
	output reg [1:0] ALUOp,
	output reg MemWrite,
	output reg ALUSrc,
	output reg RegWrite
	
);

initial
	begin
		ALUSrc = 1'b0;
		MemtoReg = 1'b0;
		RegWrite = 1'b0;
		MemRead = 1'b0;
		MemWrite = 1'b0;
		Branch = 1'b0;
		ALUOp = 2'b00;	
	end

always @(*)
	begin
		case(Opcode)
				7'b0110011:
                  	begin
					ALUSrc = 1'b0;
					MemtoReg = 1'b0;
					RegWrite = 1'b1;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					Branch = 1'b0;
					ALUOp = 2'b10;
                    end
				7'b0000011:
                 	begin
					ALUSrc = 1'b1;
					MemtoReg = 1'b1;
					RegWrite = 1'b1;
					MemRead = 1'b1;
					MemWrite = 1'b0;
					Branch = 1'b0;
					ALUOp = 2'b00;
                    end
				7'b0100011:
                    begin
					ALUSrc = 1'b1;
					RegWrite = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b1;
					Branch = 1'b0;
					ALUOp = 2'b00;
                    end
				7'b1100011:
                    begin
					ALUSrc = 1'b0;
					RegWrite = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					Branch = 1'b1;
					ALUOp = 2'b01;
                    end
				7'b0010011: 		//for addi instruction
                  	begin
					ALUSrc = 1'b1;
					MemtoReg = 1'b0;
					RegWrite = 1'b1;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					Branch = 1'b0;
					ALUOp = 2'b10;
                    end
			endcase						
	end
	
endmodule


// Addi x5, x6, 8 --> needs to read acces a register, needs to write access a register, needs to perform addition on ALU, ALU source needs to be from immediate data generator, not another register
// RegWrite = 1
// ALUSrc = 1
// MemtoReg = 0
// MemRead = 0
// Branch = 0


module ALU_Control 
(
	input [1:0] ALUOp,
	input [3:0] Funct,
	output reg [3:0] Operation
);

always @ (*)
	begin 
		if (ALUOp == 2'b00)
			begin
				Operation = 4'b0010;
			end
		else if (ALUOp == 2'b01)
			begin
				Operation = 4'b0110;		
			end
		
		else if (ALUOp == 2'b10)
			begin
				case (Funct)
					4'b0000:
                      	begin
						Operation = 4'b0010;
                        end
					4'b1000:
                      	begin
						Operation = 4'b0110;
                        end
					4'b0111:
                      	begin
						Operation = 4'b0000;
                        end
					4'b0110:
                      	begin
						Operation = 4'b0001;
                        end
				endcase
			end
		
	end

endmodule


module top_control
(
	input [6:0] Opcode,
	input [3:0] Funct,
	output Branch,
	output MemRead,
	output MemtoReg,
  	output [3:0] Operation,
	output MemWrite,
	output ALUSrc,
	output RegWrite
);

wire [1:0] ALUOp;

ALU_Control AC
(
	.ALUOp(ALUOp),
	.Funct(Funct),
	.Operation(Operation)
);

Control_Unit CU
(
	.Opcode(Opcode),
	.Branch(Branch),
	.MemRead(MemRead),
	.MemtoReg(MemtoReg),
	.MemWrite(MemWrite),
	.ALUSrc(ALUSrc),
	.RegWrite(RegWrite),
	.ALUOp(ALUOp)
		
);

endmodule
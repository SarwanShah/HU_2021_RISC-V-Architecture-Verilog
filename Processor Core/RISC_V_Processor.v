module RISC_V_Processor
(
	input clock, 
	input reset
);

// For Program_Counter

wire [63:0] PC_In;
wire [63:0] PC_Out;    // goes to two adders: offset and increment
wire [63:0] Out_Inc;    // output of the increment adder, goes to MUX
wire [63:0] Out_Offset; // output of the offset adder, goes to MUX
wire [63:0] imData; 	// input to the offset adder

wire Branch;          // used on select line for PC_In selection MUX 
wire ZeroALU;         // used on select line for PC_In selection MUX

// For Instruction Memory

wire [31:0] Instruction; // Output of the instruction memory module, goes as input to Instruction Parser, Immediate Data Gen, and ALU Control

// For Instruction Parser

wire [6:0] Opcode;   // all of these are outputs from parser
wire [6:0] func7;	
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
wire [2:0] func3;

// For Register File


wire [63:0] writeData;  // input to register memory
wire regWrite;          // control input to register mem
wire [63:0] readData1;  // output of register mem
wire [63:0] readData2;	// output of register mem

// For ALU

wire ALUSrc;
wire [63:0] ALUb;
wire [63:0] ALUout;
wire [3:0] Operation;

// For Data Memory

wire MemWrite;
wire MemRead;
wire [63:0] dataMemOut;
wire MemtoReg;


// For Control Unit

wire [1:0] ALUOp;


Program_Counter PC
(
	.clock(clock),
	.reset(reset),
	.PC_In(PC_In),
	.PC_Out(PC_Out)
);

Adder_64_bit Inst_Increment
(
  	.a(PC_Out),
  	.b(64'd4),
	.result(Out_Inc)
);


Adder_64_bit Inst_Offset
(
  	.a(PC_Out),
  	.b(imData << 1),
	.result(Out_Offset)
);

MUX PC_Inst_Offset_Check
(
	.a(Out_Inc),
	.b(Out_Offset),
	.sel(Branch && ZeroALU),
	.data_out(PC_In)
);

Instruction_Memory IM
(	
	.Inst_Address(PC_Out),
	.Instruction(Instruction)
);

Instruction_Parser IP
(
	.instruction(Instruction),
	.opcode(Opcode),
	.func7(func7),
	.rd(rd),
	.rs1(rs1),
	.rs2(rs2),
	.func3(func3)
);

registerFile RF
(
	.rs1(rs1),
	.rs2(rs2),
	.rd(rd),
	.writeData(writeData),
	.regWrite(regWrite),
	.clock(clock),
	.reset(reset),
	.readData1(readData1),
	.readData2(readData2)
);

Immediate_Data_Generator IDG
(
	.instruction(Instruction),
	.imm_data(imData)
);

MUX ALU_add_imm
(
	.a(readData2),
	.b(imData),
	.sel(ALUSrc),
	.data_out(ALUb)
);

ALU_64_bit ALU
(
	.a(readData1),
	.b(ALUb),
	.Result(ALUout),
	.ALUOp(Operation),
	.Zero(ZeroALU)
);

Data_Memory DM
(
  .Mem_Addr(ALUout),
  .Write_Data(writeData),
  .clock(clock),
  .memWrite(MemWrite),
  .memRead(MemRead),
  .Read_Data(dataMemOut)
);


MUX ALUout_Read_Data_Check
(
	.b(dataMemOut),
	.a(ALUout),
	.sel(MemtoReg),
	.data_out(writeData)
);

Control_Unit CU
(
	.Opcode(Opcode),
	.Branch(Branch),
	.MemRead(MemRead),
	.MemtoReg(MemtoReg),
	.ALUOp(ALUOp),
	.MemWrite(MemWrite),
	.ALUSrc(ALUSrc),
  	.RegWrite(regWrite)
);

ALU_Control AC
(
	.ALUOp(ALUOp),
	.Funct({Instruction[30], Instruction[14-12]}),
	.Operation(Operation)
);


endmodule


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------//

module Adder_64_bit
(
	input [63:0]a,
	input [63:0]b,
	
	output reg [63:0]result
);



always @(*)
	begin
       result = a + b;
	end

endmodule


//--------------------------------------------------------------------//

			
module Program_Counter
(
	input clock,
	input reset,
	input [63:0] PC_In,
	output reg [63:0] PC_Out
	
);

initial
	begin
		PC_Out = 0;
	end
	
always @ (posedge clock)
	begin
		if (reset == 1'b0)
			PC_Out = PC_In;
	end
	
always @ (*)
	begin
		if (reset == 1'b1)
			PC_Out = 0;
	end
		
endmodule


	
//--------------------------------------------------------------------//



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
		instructionsMem[2] = 8'b10000101;
		instructionsMem[3] = 8'b00000010;
		instructionsMem[4] = 8'b10110011;
		instructionsMem[5] = 8'b10000100;
		instructionsMem[6] = 8'b10011010;
		instructionsMem[7] = 8'b00000000;
		instructionsMem[8] = 8'b10010011;
		instructionsMem[9] = 8'b10000100;
		instructionsMem[10] = 8'b00010100;
		instructionsMem[11] = 8'b00000000;
		instructionsMem[12] = 8'b00100011;
		instructionsMem[13] = 8'b00110100;
		instructionsMem[14] = 8'b10010101;
		instructionsMem[15] = 8'b00000010;
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
				
	
//--------------------------------------------------------------------//


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


//--------------------------------------------------------------------//


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


//--------------------------------------------------------------------//


// Code your design here
module ALU_64_bit
(
	input [63:0]a,
	input [63:0]b,
  	input [3:0] ALUOp,
	
	output reg [63:0]Result,
	output reg Zero
);



always @(*)
	begin
      case(ALUOp[3:0])
        4'b0000: 
        	Result = a & b; 
        4'b0001:
        	Result = a | b;
        4'b0010: 
        	Result = a + b;
    	4'b0110: 
        	Result = a - b;
    	4'b1100: 
          Result = ~(a | b);
      endcase
      if (Result == 64'b0)
		begin
			Zero = 64'b1;
		end
	  else
		begin
			Zero = 64'b0;
		end
	end

endmodule


//--------------------------------------------------------------------//



module Immediate_Data_Generator
(
	input [31:0] instruction,
	output reg [63:0] imm_data	
);

   reg [51:0] extension;
   
always @(*)
  begin
	case(instruction[6:5])
		2'b00:
			imm_data = instruction[31:20];
		2'b01:
			imm_data = {instruction[31:25], instruction[11:7]};
		2'b11:
          imm_data = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};

	endcase
	extension = {52{imm_data[11]}};
	imm_data = {extension, imm_data};
			
  end


endmodule



//--------------------------------------------------------------------//


module Data_Memory
(
  input [63:0] Mem_Addr,
  input [63:0] Write_Data,
  input clock,
  input memWrite,
  input memRead,
	
  output reg [63:0] Read_Data
);


reg [7:0] dataMem [63:0];  
integer i;

initial 
	begin 
		i = 0;
		for (i = 0; i <= 63; i = i + 1)
			begin
				dataMem[i] = 8'b00000000;
			end
	end

always @ (posedge clock)
	begin
	if (memWrite == 1'b1)
		begin
          	if (Mem_Addr <= 56)
				begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                  dataMem[Mem_Addr+1] = Write_Data[15:8];
                  dataMem[Mem_Addr+2] = Write_Data[23:9];
                  dataMem[Mem_Addr+3] = Write_Data[31:24];
                  dataMem[Mem_Addr+4] = Write_Data[39:32];
                  dataMem[Mem_Addr+5] = Write_Data[47:40];
                  dataMem[Mem_Addr+6] = Write_Data[55:48];
                  dataMem[Mem_Addr+7] = Write_Data[63:56];
                end
          	else if (Mem_Addr == 57)
				begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                  dataMem[Mem_Addr+1] = Write_Data[15:8];
                  dataMem[Mem_Addr+2] = Write_Data[23:9];
                  dataMem[Mem_Addr+3] = Write_Data[31:24];
                  dataMem[Mem_Addr+4] = Write_Data[39:32];
                  dataMem[Mem_Addr+5] = Write_Data[47:40];
                  dataMem[Mem_Addr+6] = Write_Data[55:48];
                end
          else if (Mem_Addr == 58)
				begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                  dataMem[Mem_Addr+1] = Write_Data[15:8];
                  dataMem[Mem_Addr+2] = Write_Data[23:9];
                  dataMem[Mem_Addr+3] = Write_Data[31:24];
                  dataMem[Mem_Addr+4] = Write_Data[39:32];
                  dataMem[Mem_Addr+5] = Write_Data[47:40];
                end
          else if (Mem_Addr == 59)
				begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                  dataMem[Mem_Addr+1] = Write_Data[15:8];
                  dataMem[Mem_Addr+2] = Write_Data[23:9];
                  dataMem[Mem_Addr+3] = Write_Data[31:24];
                  dataMem[Mem_Addr+4] = Write_Data[39:32];
                end
          else if (Mem_Addr == 60)
				begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                  dataMem[Mem_Addr+1] = Write_Data[15:8];
                  dataMem[Mem_Addr+2] = Write_Data[23:9];
                  dataMem[Mem_Addr+3] = Write_Data[31:24];
                end
          else if (Mem_Addr == 61)
				begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                  dataMem[Mem_Addr+1] = Write_Data[15:8];
                  dataMem[Mem_Addr+2] = Write_Data[23:9];
                end
          else if (Mem_Addr == 62)
				begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                  dataMem[Mem_Addr+1] = Write_Data[15:8];
                end
          else
				begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                end
		end
	end

  
always @ (*)
	begin
	if (memRead == 1'b1)
		begin
          	if (Mem_Addr <= 56)
				begin
                  Read_Data = {dataMem[Mem_Addr+7], dataMem[Mem_Addr+6], dataMem[Mem_Addr+5], dataMem[Mem_Addr+4], dataMem[Mem_Addr+3], dataMem[Mem_Addr+2], dataMem[Mem_Addr+1], dataMem[Mem_Addr]};
                end
          	else if (Mem_Addr == 57)
				begin
                  Read_Data = {dataMem[Mem_Addr+6], dataMem[Mem_Addr+5], dataMem[Mem_Addr+4], dataMem[Mem_Addr+3], dataMem[Mem_Addr+2], dataMem[Mem_Addr+1], dataMem[Mem_Addr]};
                end
          else if (Mem_Addr == 58)
				begin
                  Read_Data = {dataMem[Mem_Addr+5], dataMem[Mem_Addr+4], dataMem[Mem_Addr+3], dataMem[Mem_Addr+2], dataMem[Mem_Addr+1], dataMem[Mem_Addr]};
                end
          else if (Mem_Addr == 59)
				begin
                  Read_Data = {dataMem[Mem_Addr+4], dataMem[Mem_Addr+3], dataMem[Mem_Addr+2], dataMem[Mem_Addr+1], dataMem[Mem_Addr]};
                end
          else if (Mem_Addr == 60)
				begin
                  Read_Data = {dataMem[Mem_Addr+3], dataMem[Mem_Addr+2], dataMem[Mem_Addr+1], dataMem[Mem_Addr]};
                end
          else if (Mem_Addr == 61)
				begin
                  Read_Data = {dataMem[Mem_Addr+2], dataMem[Mem_Addr+1], dataMem[Mem_Addr]};
                end
          else if (Mem_Addr == 62)
				begin
                  Read_Data = {dataMem[Mem_Addr+1], dataMem[Mem_Addr]};
                end
          else
            begin
              Read_Data = dataMem[Mem_Addr];
            end
              	

		end
	end
  
endmodule


	
//--------------------------------------------------------------------//
			
			
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

//--------------------------------------------------------------------//


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


module MUX
(
	input [63:0] a,
	input [63:0] b,
	input sel,
	
	output reg [63:0] data_out

);

always @(*)
	begin
      case(sel)
        1'b0: 
        	data_out = a; 
        1'b1: 
        	data_out = b;
      endcase
	end


endmodule 
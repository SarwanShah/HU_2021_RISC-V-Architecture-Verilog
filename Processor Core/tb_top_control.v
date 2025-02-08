module tb_top_control
();

	reg [6:0] Opcode;
	reg [3:0] Funct;
	wire Branch;
	wire MemRead;
	wire MemtoReg;
	wire [3:0] Operation;
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	
top_control TC
(
	.Opcode(Opcode),
	.Funct(Funct),
	.Branch(Branch),
	.MemRead(MemRead),
	.MemWrite(MemWrite),
	.MemtoReg(MemtoReg),
	.Operation(Operation),
	.ALUSrc(ALUSrc),
	.RegWrite(RegWrite)
);

initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars;
		
		
		Opcode = 7'b0110011;
		Funct = 4'b0000;
		
      	#10

		Opcode = 7'b0110011;
      	Funct = 4'b1000;	
	
		#10

		Opcode = 7'b0110011;
		Funct = 4'b0111;	
	
		#10
	
		Opcode = 7'b0110011;
		Funct = 4'b0110;	
	
		#10

		Opcode = 7'b0000011;
		Funct = 4'b0000;	
	
		#10

		Opcode = 7'b0100011;
		Funct = 4'b0000;

		#10

		Opcode = 7'b1100011;
		Funct = 4'b0000;
	
      	#10

		Opcode = 7'b0010011;
		Funct = 4'b0000;
      
      	#10
      
		Opcode = 7'b0010011;
		Funct = 4'b0001;
      	
        #10
		
		
		$finish;
	end


endmodule
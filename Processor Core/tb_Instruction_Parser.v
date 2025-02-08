module tb
();

	reg [63:0] instruction;
	
	wire [6:0] opcode;
	wire [6:0] func7;
	
	wire [4:0] rd;
	wire [4:0] rs1;
	wire [4:0] rs2;
	
	wire [2:0] func3;
	
	
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
	
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
		
		instruction = 32'b1000000000000101000001000110011; // sub x4, x5, x0
		#10
		
		instruction = 32'b11100110000001010110011;       // add x5, x6, x7
		#10
     
      	instruction = 32'b11100110000001010110010;
		#10
		
		
		$finish;	
	end
		
endmodule
		
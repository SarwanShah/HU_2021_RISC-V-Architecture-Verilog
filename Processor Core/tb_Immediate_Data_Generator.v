module tb
();

	reg [31:0] instruction;
	wire [63:0] imm_data;
	
	
	
	Immediate_Data_Generator IDM
	(
		.instruction(instruction),
		.imm_data(imm_data)
	);
	
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
		
		instruction = 32'h00001263; // bne x0, x0, EXIT
		#10
		
		instruction = 32'b10100000000001010010011;   // addi x5, x0, 5
		#10
     
      	instruction = 32'b10100101010000000100011;  // sw x5, 0x00(x5)
		#10
		
		instruction = 32'b1110000000000101011011; // random
		#10
		
		
		$finish;	
	end
		
endmodule
		
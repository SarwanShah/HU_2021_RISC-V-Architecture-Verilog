module tb_Instruction_Fetch
();

	reg clock;
	reg reset;
	wire [31:0] Instruction;
	
Instruction_Fetch IF
(
  .clock(clock),
  .reset(reset),
	.Instruction(Instruction)
);

initial
	begin

		$dumpfile("dump.vcd");
		$dumpvars;
		
		clock = 1'b0;	
		reset = 0;
		
      	#10
		
		#10

		#10
		
      	#10
		
		reset = 1;
		
		#10
		
		reset = 0;
		
		#10		
		#10
		
		reset = 1;
		
		$finish;		
	
	end

always
#10 clock = ~clock;	

endmodule
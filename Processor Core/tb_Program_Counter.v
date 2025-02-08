module tb_Program_Counter
();

	reg [63:0] PC_In;
	reg clock;
	reg reset;
	wire [63:0] PC_Out;
	
Program_Counter PC
(
	.PC_In(PC_In),
	.clock(clock),
	.reset(reset),
	.PC_Out(PC_Out)
);

initial
	begin

		$dumpfile("dump.vcd");
		$dumpvars;
		
		clock = 1'b0;	
		
		reset = 0;
		PC_In = 10;
		
      	#10
		#10
		
		reset = 0;
		PC_In = 20;
		
		#10
      	#10
		
		PC_In = 6;
		
		#10
		
		PC_In = 12;
		
		#10
		
		reset = 1;
		
		#10
		
		reset = 0;
		
		$finish;		
	
	end

always
#10 clock = ~clock;	
	

	
endmodule
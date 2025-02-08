module tb_RISC_V_Processor
();

reg clock;
reg reset;

RISC_V_Processor RISC
(
	.clock(clock),
	.reset(reset)
);

initial
	begin

		$dumpfile("dump.vcd");
		$dumpvars;
		
		clock = 1'b0;
		reset = 1;
		
      	#10
      
      	reset = 0;

      	#20
      
      	reset = 1;
		

		$finish;		
	
	end

always
#5 clock = ~clock;	

endmodule
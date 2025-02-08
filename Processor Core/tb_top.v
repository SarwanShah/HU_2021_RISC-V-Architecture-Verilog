module tb_top
();

  reg [31:0] instruction;
  wire [63:0] readData1;
  wire [63:0] readData2;
	
	reg regWrite;
	reg clock;
	reg reset;
	
	
	top tp
	(
      .instruction(instruction),
      .readData1(readData1),
      .readData2(readData2),
      .regWrite(regWrite),
      .clock(clock),
      .reset(reset)
	);
	
	initial
      begin
		$dumpfile("dump.vcd");
		$dumpvars;
		
		clock = 1'b0;
		

        instruction = 32'b00000000011100110000001010110011;
		reset = 0;
        regWrite = 0;
	

		#10
		
        instruction = 32'b00000000011100110000001110110011;
		reset = 0;
        regWrite = 1;
		
		#10

       	instruction = 32'b00000000011100110000001110110011;
		reset = 1;
        regWrite = 0;
		
		#10
		
		
		$finish;	
	end

always
#10 clock = ~clock ;
		
endmodule
	
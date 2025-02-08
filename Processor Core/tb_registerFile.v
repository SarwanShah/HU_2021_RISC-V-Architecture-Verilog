module tb_registerFile
();

    reg [4:0] rs1;
	reg [4:0] rs2;
	reg [4:0] rd;
	
	reg clock;
	reg reset;

	reg [63:0] writeData;
	reg regWrite;
	
    wire [63:0] readData1;
    wire [63:0] readData2;
	
	
	registerFile RF
	(
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.reset(reset),
		.clock(clock),
		.writeData(writeData),
		.regWrite(regWrite),
		.readData1(readData1),
		.readData2(readData2)
	);
	
	initial
      begin
		$dumpfile("dump.vcd");
		$dumpvars;
		
		clock = 1'b0;
		
		
		reset = 1'b0;
		regWrite = 1'b1;
		writeData = 20;
		rs1 = 5;
		rs2 = 6;
		rd = 1;
		
		#10
	
		reset = 1'b0;
		regWrite = 1'b1;
		writeData = 15;
		rs1 = 5;
		rs2 = 6;
		rd = 5;
		
		#10

		reset = 1'b1;
		regWrite = 1'b0;
		writeData = 15;
		rs1 = 5;
		rs2 = 6;
		rd = 1;
     
		#10
		
		reset = 1'b0;
		regWrite = 1'b0;
		writeData = 10;
		rs1 = 5;
		rs2 = 6;
		rd = 7;
		
		
		$finish;	
	end

always
#10 clock = ~clock ;
		
endmodule
	
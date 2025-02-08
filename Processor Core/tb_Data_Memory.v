module tb_Data_Memory
();

	reg [63:0] Mem_Addr;
	reg [63:0] Write_Data;
	reg clock;
	reg memWrite;
	reg memRead;
	
	wire [63:0] Read_Data;
	
Data_Memory DM
(
	.Mem_Addr(Mem_Addr),
	.Write_Data(Write_Data),
	.clock(clock),
	.memWrite(memWrite),
  	.memRead(memRead),
  	.Read_Data(Read_Data)
);

initial
	begin

		$dumpfile("dump.vcd");
		$dumpvars;
		
		clock = 1'b0;	

		Mem_Addr = 0;
		Write_Data = 0;
		memWrite = 0;
		memRead = 1;		

		#10

		Mem_Addr = 10;
		Write_Data = 10;
		memWrite = 1;
		memRead = 1;
     
		#10
      	#10

		Mem_Addr = 10;
		Write_Data = 5;
		memWrite = 1;
		memRead = 1;
     	
		#10
      	#10
 
 		Mem_Addr = 60;
		Write_Data = 15;
		memWrite = 0;
		memRead = 1;
 	
		
		#10
      	#10
      
 		Mem_Addr = 63;
		Write_Data = 286;
		memWrite = 1;
		memRead = 0;
		
		#10
        #10

 		Mem_Addr = 63;
		Write_Data = 0;
		memWrite = 0;
		memRead = 1;

      		#10

 		Mem_Addr = 63;
		Write_Data = 0;
		memWrite = 0;
		memRead = 0;
		
		$finish;		
	
	end

always
#10 clock = ~clock;	
	
endmodule
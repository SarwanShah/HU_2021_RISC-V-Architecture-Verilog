module tb_Instruction_Memory
();

	reg [61:0] Inst_Address;
	wire [31:0] Instruction;
	
	
	Instruction_Memory IM
	(
		.Inst_Address(Inst_Address),
		.Instruction(Instruction)
	);
	
initial
      begin
		$dumpfile("dump.vcd");
		$dumpvars;
		
		
	
		Inst_Address = 0;
		
		#10

		Inst_Address = 2;
     
		#10
	
		Inst_Address = 3;
		
		#10
        
 	
		Inst_Address = 14;
		
		#10
		
		Inst_Address = 12;
		
		$finish;	
	end

		
endmodule
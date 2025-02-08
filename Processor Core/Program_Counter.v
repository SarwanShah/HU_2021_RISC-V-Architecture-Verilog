module Program_Counter
(
	input clock,
	input reset,
	input [63:0] PC_In,
	output reg [63:0] PC_Out
	
);

initial
	begin
		PC_Out = 0;
	end
	
always @ (posedge clock)
	begin
		if (reset == 1'b0)
			PC_Out = PC_In;
	end
	
always @ (*)
	begin
		if (reset == 1'b1)
			PC_Out = 0;
	end
		
endmodule
	
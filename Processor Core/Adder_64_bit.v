module Adder_64_bit
(
	input [63:0]a,
	input [63:0]b,
	
	output reg [63:0]result,
);



always @(*)
	begin
       result = a + b;
	end

endmodule
module MUX
(
	input [63:0] a,
	input [63:0] b,
	input sel,
	
	output reg [63:0] data_out

);

always(*)
	begin
      case(sel)
        1'b0: 
        	data_out = a; 
        1'b1: 
        	data_out = b;
      endcase
	end


endmodule 
module Immediate_Data_Generator
(
	input [31:0] instruction,
	output reg [63:0] imm_data	
);

   reg [51:0] extension;
   
always @(*)
  begin
	case(instruction[6:5])
		2'b00:
			imm_data = instruction[31:20];
		2'b01:
			imm_data = {instruction[31:25], instruction[11:7]};
		2'b11:
          imm_data = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};

	endcase
	extension = {52{imm_data[11]}};
	imm_data = {extension, imm_data};
			
  end


endmodule
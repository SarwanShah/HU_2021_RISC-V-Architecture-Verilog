module tb
();

	reg [63:0] a
	reg [63:0] b
	
	wire [63:0] data_out
	
	MUX M1
	(
		.a(a),
		.b(b),
		.data_out(data_out)
	);
	
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
		
		a = 53;
		b = 128;
		sel = 0;
		#10
		
		a = 53
		b = 128;
		sel = 1;
		#10
		
		a = 32;
		b = 128;
		sel = 0;
		#10
		
		$finish;	
	end
		
endmodule
		
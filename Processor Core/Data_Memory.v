module Data_Memory
(
  input [63:0] Mem_Addr,
  input [63:0] Write_Data,
  input clock,
  input memWrite,
  input memRead,
	
  output reg [63:0] Read_Data
);


reg [7:0] dataMem [63:0];  
integer i;

initial 
	begin 
		i = 0;
		for (i = 0; i <= 63; i = i + 1)
			begin
				dataMem[i] = 8'b00000000;
			end
	end

always @ (posedge clock)
	begin
	if (memWrite == 1'b1)
		begin
                  dataMem[Mem_Addr] = Write_Data[7:0];
                  dataMem[Mem_Addr+1] = Write_Data[15:8];
                  dataMem[Mem_Addr+2] = Write_Data[23:9];
                  dataMem[Mem_Addr+3] = Write_Data[31:24];
                  dataMem[Mem_Addr+4] = Write_Data[39:32];
                  dataMem[Mem_Addr+5] = Write_Data[47:40];
                  dataMem[Mem_Addr+6] = Write_Data[55:48];
                  dataMem[Mem_Addr+7] = Write_Data[63:56];
        end
	end

  
always @ (*)
	begin
	if (memRead == 1'b1)
		begin
          Read_Data = {dataMem[Mem_Addr+7], dataMem[Mem_Addr+6], dataMem[Mem_Addr+5], dataMem[Mem_Addr+4], dataMem[Mem_Addr+3], dataMem[Mem_Addr+2], dataMem[Mem_Addr+1], dataMem[Mem_Addr]};         	

		end
	end
  
endmodule
	
			
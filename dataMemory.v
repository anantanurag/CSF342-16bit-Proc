module dataMemory(	D_Data,
					A_DataAddress,
					D_WriteData,
					C_DMRead, C_DMWrite,
					clk, rst
					);

output reg [15:0] D_Data;
input wire [15:0] A_DataAddress;
input wire [15:0] D_WriteData;
input wire C_DMRead, C_DMWrite;
input wire clk, rst;

reg [15:0] memory[0:8192]; // 8192 = 8*1024, 8k*2bytes=16kB
initial $readmemh("data_file.txt", memory);

always @(posedge clk or rst) begin
	if (rst == 1) begin
		D_Data = 16'b0000_0000_0000_0000;
	end
	else begin
		if (C_DMWrite == 1) begin
			memory[A_DataAddress] <= D_WriteData;
		end
		else begin
			memory[A_DataAddress] <= memory[A_DataAddress];
		end

		if (C_DMRead == 1) begin
			D_Data <= memory[A_DataAddress];
		end
		else begin
			D_Data <= D_Data;
		end
	end 
end

endmodule
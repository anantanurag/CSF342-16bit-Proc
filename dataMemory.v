`timescale 1ns/10ps
module tb_dataMemory();

reg [15:0] A_DataAddress;
reg [15:0] D_WriteData;
reg C_DMRead, C_DMWrite, clk, rst;
wire [15:0] D_Data;

dataMemory uut (D_Data,	A_DataAddress,D_WriteData,C_DMRead, C_DMWrite,clk, rst);

initial
begin
	#00 clk <= 1'b0;
	forever #10 clk <= ~clk;
end

initial
begin
	#00 rst = 1'b1;
	#30 rst = 1'b0;
end

initial
begin
	#00  C_DMRead = 1'b1; C_DMWrite = 1'b0;
	#200 C_DMRead = 1'b0; C_DMWrite = 1'b1;
	#200 C_DMRead = 1'b0; C_DMWrite = 1'b0;
	#200 C_DMRead = 1'b1; C_DMWrite = 1'b1; 
	#200 $stop;
end

initial
begin
	#00 A_DataAddress <= 16'd0;
	#50 A_DataAddress <= 16'd1;
	#50 A_DataAddress <= 16'd1;
	#50 A_DataAddress <= 16'd2;
end

initial
begin
	#00  D_WriteData = 16'd20;
end

initial
begin
	$dumpfile("dataMemory.vcd");
	$dumpvars;
end

initial
begin
	$monitor("time=%3d, D_Data=%16h, D_WriteData=%16h, A_DataAddress=%16h", $time, D_Data, D_WriteData, A_DataAddress);
end

endmodule


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
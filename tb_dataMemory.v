`timescale 1ns/10ps
module tb_dataMemory();

reg [15:0] A_DataAddress;
reg [15:0] D_WriteData;
reg C_DMRead, C_DMWrite, rst;
wire [15:0] D_Data;

dataMemory uut (D_Data,	A_DataAddress,D_WriteData,C_DMRead, C_DMWrite, rst);



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



`timescale 1ns/10ps
module tb_dataMemory();

reg [15:0]PC_IN;
reg  clk, C_PCWrite;
wire [15:0] PC_OUT;

programCounter uut(PC_OUT, PC_IN, C_PCWrite, clk);

initial
begin
	#000 clk = 1'b1;
	forever #10 clk <= ~clk;
end

initial
begin	
	#00 C_PCWrite=1'b1;	PC_IN <= 16'd15;
	#50 PC_IN <= 16'd20;
	#50 PC_IN <= 16'd01;
	#50 C_PCWrite <= 1'b0;
	#50 PC_IN <= 16'd0;
	#50 $stop;
end

initial
begin
	$dumpfile("programCounter.vcd");
	$dumpvars;
end

initial $monitor("time=%3d, PC_OUT=%16h, PC_IN=%16h, C_PCWrite=%b", $time, PC_OUT, PC_IN, C_PCWrite);

endmodule



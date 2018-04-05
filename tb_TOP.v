`timescale 1ns/10ps
`include "TOP.v"

module tb_TOP();

	reg clk, rst;

	TOP uut(clk, rst);

	initial
	begin
		#00 clk = 1'b0;
		forever #10 clk = ~clk;
	end

	initial
	begin
		#000 rst = 1'b0;
		#005 rst = 1'b1;
		#015 rst = 1'b0;
		// #500 rst = 1'b1;
		#1000 $finish;
	end

	initial
	begin
		$dumpfile("TOP.vcd");
		$dumpvars;
	end

endmodule
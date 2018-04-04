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
		rst = 1'b1;
		#500 rst = 1'b0;
		#500 rst = 1'b1;
		$stop;
	end

	initial
	begin
		$dumpfile("TOP.vcd");
		$dumpvars;
	end

endmodule
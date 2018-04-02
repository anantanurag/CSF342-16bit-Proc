`timescale 1ns/10ps

module tb_memoryDataRegister();
	
	wire [15:0] D_OUT;

	reg [15:0] D_IN;
	reg clk;

	memoryDataRegister uut(D_OUT, D_IN, clk);

	initial
	begin
		#00 clk = 1'b0;
		forever #10 clk = ~clk;
	end

	initial
	begin
		#27 D_IN = 16'd54;
		#27 D_IN = 16'd977;
		#27 D_IN = 16'd0;
		#27 D_IN = 16'd6516;
		#27 D_IN = 16'd515;
		#27 D_IN = 16'd333;
		#27 D_IN = 16'd1804;
		
		$stop;
	end

	initial
	begin
		$dumpfile("memoryDataRegister.vcd");
		$dumpvars;
	end

endmodule


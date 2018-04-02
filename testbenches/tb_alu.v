`timescale 1ns/10ps

module tb_alu();

	wire [15:0] out;
	wire z;
	reg [15:0] a,b;
	reg [2:0] op;

	alu uut(out,z,a,b,op);

	initial
		begin
		#20  op=3'd0; a=16'd54; b=16'd5;
		#20  op=3'd1; a=16'd54; b=16'd5;
		#20  op=3'd2; a=16'd54; b=16'd5;
		#20  op=3'd3; a=16'd54; b=16'd5;
		#20  op=3'd4; a=16'd54; b=16'd5;
		#20  op=3'd5; a=16'd54; b=16'd5;
		#20  op=3'd6; a=16'd54; b=16'd5;
		#20  op=3'd7; a=16'd54; b=16'd5;
		#20  $stop;
		end

	initial
		begin
		$dumpfile("alu.vcd");
		$dumpvars;
		end

endmodule


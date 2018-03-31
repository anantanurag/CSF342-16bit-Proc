`timescale 1ns/1ps

/*

	***Register file***

	All resets are synchronous.
	All clock edges are posedges.
	Behavioral Modelling is followed wherever possible.

	Modules: 
		1. Main Register File (registerFile)
		2. 16-bit Register (register_16bit)
		3. Decoder
		4. MUX (mux16to1)

*/

module registerFile (read_data1, read_data2, clk, rst, ctrl_reg_write, read_reg1, read_reg2, write_reg, write_data);
	
	output [15:0] read_data1, read_data2; //The outputs to internal registers A and B.
	input [3:0] read_reg1, read_reg2, write_reg; //The three inputs from he instruction register to the register file.
	input [15:0] write_data; //Data to be written to the register at reg_write signal.
	input clk, rst, ctrl_reg_write;
	wire [15:0] deco_out, reg_in;
	reg [15:0] reg_out [15:0];
	
	decoder4to16 deco (deco_out, write_reg);
	
	and and0 (reg_in[0], ctrl_reg_write, deco_out[0], clk);
	and and1 (reg_in[1], ctrl_reg_write, deco_out[1], clk);
	and and2 (reg_in[2], ctrl_reg_write, deco_out[2], clk);
	and and3 (reg_in[3], ctrl_reg_write, deco_out[3], clk);
	and and4 (reg_in[4], ctrl_reg_write, deco_out[4], clk);
	and and5 (reg_in[5], ctrl_reg_write, deco_out[5], clk);
	and and6 (reg_in[6], ctrl_reg_write, deco_out[6], clk);
	and and7 (reg_in[7], ctrl_reg_write, deco_out[7], clk);
	and and8 (reg_in[8], ctrl_reg_write, deco_out[8], clk);
	and and9 (reg_in[9], ctrl_reg_write, deco_out[9], clk);
	and and10 (reg_in[10], ctrl_reg_write, deco_out[10], clk);
	and and11 (reg_in[11], ctrl_reg_write, deco_out[11], clk);
	and and12 (reg_in[12], ctrl_reg_write, deco_out[12], clk);
	and and13 (reg_in[13], ctrl_reg_write, deco_out[13], clk);
	and and14 (reg_in[14], ctrl_reg_write, deco_out[14], clk);
	and and15 (reg_in[15], ctrl_reg_write, deco_out[15], clk);
	
	register_16bit r0 (reg_out[0], write_data, reg_in[0], clk, rst);
	register_16bit r1 (reg_out[1], write_data, reg_in[1], clk, rst);
	register_16bit r2 (reg_out[2], write_data, reg_in[2], clk, rst);
	register_16bit r3 (reg_out[3], write_data, reg_in[3], clk, rst);
	register_16bit r4 (reg_out[4], write_data, reg_in[4], clk, rst);
	register_16bit r5 (reg_out[5], write_data, reg_in[5], clk, rst);
	register_16bit r6 (reg_out[6], write_data, reg_in[6], clk, rst);
	register_16bit r7 (reg_out[7], write_data, reg_in[7], clk, rst);
	register_16bit r8 (reg_out[8], write_data, reg_in[8], clk, rst);
	register_16bit r9 (reg_out[9], write_data, reg_in[9], clk, rst);
	register_16bit r10 (reg_out[10], write_data, reg_in[10], clk, rst);
	register_16bit r11 (reg_out[11], write_data, reg_in[11], clk, rst);
	register_16bit r12 (reg_out[12], write_data, reg_in[12], clk, rst);
	register_16bit r13 (reg_out[13], write_data, reg_in[13], clk, rst);
	register_16bit r14 (reg_out[14], write_data, reg_in[14], clk, rst);
	register_16bit r15 (reg_out[15], write_data, reg_in[15], clk, rst);

	mux16to1 mux1 (read_data1, reg_out, read_reg1);
	mux16to1 mux2 (read_data2, reg_out, read_reg2);

endmodule



module mux16to1 (out, in, sel);

	output out;
	input [15:0] in;
	input [3:0] sel;

	reg out;
	always @(sel or in)
	begin
		case(sel)
			4'b0000: out<=in[0];
			4'b0001: out<=in[1];
			4'b0010: out<=in[2];
			4'b0011: out<=in[3];
			4'b0100: out<=in[4];
			4'b0101: out<=in[5];
			4'b0110: out<=in[6];
			4'b0111: out<=in[7];
			4'b1000: out<=in[8];
			4'b1001: out<=in[9];
			4'b1010: out<=in[10];
			4'b1011: out<=in[11];
			4'b1100: out<=in[12];
			4'b1101: out<=in[13];
			4'b1110: out<=in[14];
			4'b1111: out<=in[15];
			default: out<=4'bzzzz;
		endcase
	end

endmodule

module register_16bit (out, in, reg_write, clk, rst);

	output reg [15:0] out;
	input [15:0] in;
	input clk, rst, reg_write;

	always @(posedge clk)
	begin
		if(rst)
			out <= 16'b0000_0000_0000_0000;
		else if(reg_write)
			out <= in;
	end

endmodule

module decoder4to16 (out, in);
	
	output [15:0] out;
	input [3:0] in;

	always @(in)
	begin
		case(in)
			4'b0000: out[0]<=1'b1;
			4'b0001: out[1]<=1'b1;
			4'b0010: out[2]<=1'b1;
			4'b0011: out[3]<=1'b1;
			4'b0100: out[4]<=1'b1;
			4'b0101: out[5]<=1'b1;
			4'b0110: out[6]<=1'b1;
			4'b0111: out[7]<=1'b1;
			4'b1000: out[8]<=1'b1;
			4'b1001: out[9]<=1'b1;
			4'b1010: out[10]<=1'b1;
			4'b1011: out[11]<=1'b1;
			4'b1100: out[12]<=1'b1;
			4'b1101: out[13]<=1'b1;
			4'b1110: out[14]<=1'b1;
			4'b1111: out[15]<=1'b1;
			default: out<=16'b0000_0000_0000_0000;
		endcase
	end

endmodule
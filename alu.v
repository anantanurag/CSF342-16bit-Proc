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

module alu (	out,z,
				a,b,
				alu_op
				);

	output reg [15:0] out;
	output reg z;
	
	input wire [15:0] a,b;
	input wire [2:0] alu_op;

	parameter ADD 	= 3'b000 ;
	parameter SUB 	= 3'b001 ;
	parameter SHR 	= 3'b010 ;// shift right a by b bits
	parameter SHL 	= 3'b011 ;// shift left a by b bits 
	parameter NAND 	= 3'b100 ;
	parameter OR 	= 3'b101 ;
	parameter DIR 	= 3'b110 ;
	parameter SAR	= 3'b111 ;// shift arithmetic right

	always@(*)
	begin
		case(alu_op)
		ADD	:	begin	
					out <= a+b;
					z <= (out==0);
				end
		SUB	: 	begin
					out <= a-b;
					z <= (out==0);
				end
		SHR	:	begin
					out <= a>>b;
					z <= (out==0);
				end
		SHL	:	begin
					out <= a<<b;
					z <= (out==0);
				end
		NAND:	begin
					out <= ~(a&b);
					z <= (out==0);
				end
		OR	:	begin
					out <= a|b;
					z <= (out==0);
				end
		DIR	:	begin
					out <= a;
					z <= (out==0);
				end
		SAR	:	begin
					out <= a>>>b;
					z <= (out==0);
				end
		default:begin
					out <= 16'd0;
					z <= 1'bz;
				end
		endcase
	end

endmodule


module ALUOut(ALUOUT_OUT, ALUOUT_IN, clk);
output reg [15:0] ALUOUT_OUT;
input wire [15:0] ALUOUT_IN;
input wire clk;

always@(posedge clk)
begin
 	ALUOUT_OUT <= ALUOUT_IN;
end
endmodule

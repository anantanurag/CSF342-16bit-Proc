module alu (	out,z,
				a,b,
				alu_op,
				clk
				);

	output reg [15:0] out;
	output reg z;
	
	input wire [15:0] a,b;
	input wire [2:0] alu_op;
	input wire clk;

	parameter ADD 	= 3'b000 ;
	parameter SUB 	= 3'b001 ;
	parameter SHR 	= 3'b010 ;// shift right a by b bits
	parameter SHL 	= 3'b011 ;// shift left a by b bits 
	parameter NAND 	= 3'b100 ;
	parameter OR 	= 3'b101 ;
	parameter DIR 	= 3'b110 ;
	parameter SAR	= 3'b111 ;// shift arithmetic right

	always@(posedge clk)
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
					out <= {a[15],a[15:1]};
					z <= (out==0);
				end
		default:begin
					out <= 16'd0;
					z <= 1'bz;
				end
		endcase
	end
endmodule
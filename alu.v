module alu(y,z,a,b,alu_op);

output reg [15:0] y;
output reg z;
input [15:0] a,b;

always@(posedge clk)
begin
case(alu_op)
	3'b000	:	begin	
					y <= a+b;
					z <= (y==0);
				end
	3'b001	: 	begin
					y <= a-b;
					z <= (y==0);
				end
	3'b010	:	begin
					y <= a>>b;
					z <= (y==0);
				end
	3'b011	:	begin
					y <= a<<b;
					z <= (y==0);
				end
	3'b100	:	begin
					y <= ~(a&b);
					z <= (y==0);
				end
	3'b101	:	begin
					y <= a|b;
					z <= (y==0);
				end
	3'b110	:	begin
					y <= a;
					z <= (y==0);
				end
	default :	begin
					y <= 16'd0;
					z <= 1'bz;
				end
endcase
end	


					

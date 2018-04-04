module programCounter(PC_OUT, PC_IN, C_PCWrite, clk, rst);
output reg [15:0] PC_OUT;
input wire [15:0] PC_IN;
input wire C_PCWrite;
input wire clk, rst;

always@(posedge clk)
begin
if(rst == 1'b1)
begin
	PC_OUT <= 16'd0;
end
else begin
	if (C_PCWrite == 1'b1) begin
 		PC_OUT <= PC_IN;
 	end
 	else begin
 		PC_OUT <= PC_OUT;
 	end
end
 	
	
end
endmodule
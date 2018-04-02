module programCounter(PC_OUT, PC_IN, C_PCWrite, clk);
output reg [15:0] PC_OUT;
input wire [15:0] PC_IN;
input wire C_PCWrite;
input wire clk;

always@(posedge clk)
begin
 	if (C_PCWrite == 1'b1) begin
 		PC_OUT <= PC_IN;
 	end
 	else begin
 		PC_OUT <= PC_OUT;
 	end
	
end
endmodule
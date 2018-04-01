module MemoryDataRegister(D_OUT, D_IN, clk);
output reg [15:0] D_OUT;
input wire [15:0] D_IN;
input wire clk;
always@(posedge clk)
begin
	D_OUT <= D_IN;
end
endmodule
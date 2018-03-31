module MemoryDataRegister(D_OUT, D_IN);
output reg [15:0] D_OUT;
input wire [15:0] D_IN;

always@(*)
begin
	D_OUT <= D_IN;
end
endmodule
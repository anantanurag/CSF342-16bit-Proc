module programCounter(PC_OUT, PC_IN, C_PCWrite, clk);
output reg [15:0] PC_OUT;
input wire [15:0] PC_IN;
input wire C_PCWrite;
input wire clk;

always@(posedge clk)
begin
	PC_OUT <= PC_IN;
end
endmodule
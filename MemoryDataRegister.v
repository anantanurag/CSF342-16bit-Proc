module memoryDataRegister(MDR_OUT, MDR_IN, clk);
	
	output reg [15:0] MDR_OUT;
	
	input wire [15:0] MDR_IN;
	input wire clk;
	
	always@(posedge clk)
	begin
		MDR_OUT <= MDR_IN;
	end
endmodule
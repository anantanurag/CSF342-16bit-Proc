module tb_registerFile();
	
	wire [15:0] D_ReadReg1RT, D_ReadReg2RT;
	wire [15:0] D_Offset, D_RegSW;
	wire [15:0] D_BT;

	reg [3:0] A_ReadReg1RT, A_ReadReg2RT;
	reg [3:0] A_Offset, A_RegSWLW;
	reg [3:0] A_WriteRegRT_BT;
	reg [15:0] D_MDR_IN, D_ALU_IN;

	reg C_RegDstWrite, C_RegWrite, C_MemToReg;
	reg clk, rst;

	uut  registerFile(	D_ReadReg1RT, D_ReadReg2RT,
						D_Offset, D_RegSW,
						D_BT,
						D_MDR_IN, D_ALU_IN,	
						A_ReadReg1RT, A_ReadReg2RT,
						A_Offset, A_RegSWLW,
						A_WriteRegRT_BT,
						C_RegDstWrite, C_RegWrite, C_MemToReg,
						clk, rst
						);

	initial
	begin
		#00 clk = 1'b0;
		forever #10 clk = ~clk;
	end

	initial
	begin
		
	end
endmodule
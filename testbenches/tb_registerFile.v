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

	registerFile uut(	D_ReadReg1RT, D_ReadReg2RT,
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
		#5 rst = 1'b1;
		#27 rst = 1'b0; A_ReadReg1RT = 4'b0011; A_ReadReg2RT = 4'b0110; A_Offset = 4'b0010; A_RegSWLW = 4'b0111; A_WriteRegRT_BT = 4'b1110; 
		D_MDR_IN = 16'd154; D_ALU_IN = 16'd777;   	
		C_RegDstWrite = 1'b1; C_RegWrite = 1'b1; C_MemToReg = 1'b0;
		#55 rst = 1'b1;
		#27 rst = 1'b0; A_ReadReg1RT = 4'b0011; A_ReadReg2RT = 4'b0110; A_Offset = 4'b0010; A_RegSWLW = 4'b0111; A_WriteRegRT_BT = 4'b1110; 
		D_MDR_IN = 16'd154; D_ALU_IN = 16'd777;   	
		C_RegDstWrite = 1'b1; C_RegWrite = 1'b1; C_MemToReg = 1'b1;
		#55 rst = 1'b1;
		#27 rst = 1'b0; A_ReadReg1RT = 4'b0011; A_ReadReg2RT = 4'b0110; A_Offset = 4'b0010; A_RegSWLW = 4'b0111; A_WriteRegRT_BT = 4'b1110; 
		D_MDR_IN = 16'd154; D_ALU_IN = 16'd777;   	
		C_RegDstWrite = 1'b0; C_RegWrite = 1'b1; C_MemToReg = 1'b1;
		#55 rst = 1'b1;
		#27 rst = 1'b0; A_ReadReg1RT = 4'b0011; A_ReadReg2RT = 4'b0110; A_Offset = 4'b0010; A_RegSWLW = 4'b0111; A_WriteRegRT_BT = 4'b1110; 
		D_MDR_IN = 16'd154; D_ALU_IN = 16'd777;   	
		C_RegDstWrite = 1'b1; C_RegWrite = 1'b1; C_MemToReg = 1'b0;
		#55 rst = 1'b1;
		#27 rst = 1'b0; A_ReadReg1RT = 4'b0011; A_ReadReg2RT = 4'b0110; A_Offset = 4'b0010; A_RegSWLW = 4'b0111; A_WriteRegRT_BT = 4'b1110; 
		D_MDR_IN = 16'd154; D_ALU_IN = 16'd777;   	
		C_RegDstWrite = 1'b1; C_RegWrite = 1'b0; C_MemToReg = 1'b1;

		$stop;
	end

	initial
	begin
		$dumpfile("registerFile.vcd");
		$dumpvars;
	end
	
endmodule
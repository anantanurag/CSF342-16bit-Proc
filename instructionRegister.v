module instructionRegister(		OPCODE, FUNCFIELD,
								A_ReadReg1RT, A_ReadReg2RT,
								A_Offset, A_RegSWLW,
								A_WriteRegRT_BT,
								D_MemData,
								C_IRWrite,
								clk, rst
								);


	output reg [3:0] OPCODE, FUNCFIELD;
	output reg [3:0] A_ReadReg1RT, A_ReadReg2RT;
	output reg [1:0] A_Offset, A_RegSWLW;
	output reg [3:0] A_WriteRegRT_BT;

	input wire [15:0] D_MemData;
	input wire C_IRWrite;
	input wire clk, rst;

	always@(posedge clk)
	begin
		if (rst == 1) 
		begin
			OPCODE <= 4'b0000;
			FUNCFIELD <= 4'b0000;
			A_ReadReg1RT <= 4'b0000;
			A_ReadReg2RT <= 4'b0000;
			A_Offset <= 4'b0000;
			A_RegSWLW <= 4'b0000;
			A_WriteRegRT_BT <= 4'b0000;
		end
		else begin
			if (C_IRWrite == 1) 
			begin
				OPCODE <= D_MemData[15:12];
				FUNCFIELD <= D_MemData[3:0];
				A_ReadReg1RT <= D_MemData[7:4];
				A_ReadReg2RT <= D_MemData[3:0];
				A_Offset <= D_MemData[9:8];
				A_RegSWLW <= D_MemData[11:10];
				A_WriteRegRT_BT <= D_MemData[11:8];
			end
			else begin
			 	OPCODE = OPCODE;
			 	FUNCFIELD = FUNCFIELD;
			 	A_ReadReg1RT = A_ReadReg1RT;
			 	A_ReadReg2RT = A_ReadReg2RT;
			 	A_Offset = A_Offset;
			 	A_RegSWLW = A_RegSWLW;
			 	A_WriteRegRT_BT = A_WriteRegRT_BT;
			end
		end
	end


endmodule
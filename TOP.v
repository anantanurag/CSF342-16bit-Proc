`include "programCounter.v"
`include "MemoryDataRegister.v"
`include "dataMemory.v"
`include "instructionMemory.v"
`include "alu.v"
`include "instructionRegister.v"
`include "MUXpreALU.v"
`include "registerFile.v"
`include "controllerFSM.v"


module TOP(clk, rst);

input wire clk, rst;
wire [15:0] PC;



controllerFSM FSM_Main();

programCounter PC();

instructionMemory IM();

wire [1:0] A_2bit_Offset, A_2bit_RegSWLW;
wire [3:0] A_Offset, A_RegSWLW;

concat11 c11(A_RegSWLW, A_2bit_RegSWLW);
concat10 c10(A_Offset, A_2bit_Offset);

wire [3:0] OPCODE, FUNCFIELD;
wire [3:0] A_ReadReg1RT, A_ReadReg2RT;

wire [3:0] A_WriteRegRT_BT;

instructionRegister IR(OPCODE, FUNCFIELD,
						A_ReadReg1RT, A_ReadReg2RT,
						A_2bit_Offset, A_2bit_RegSWLW,
						A_WriteRegRT_BT,
						D_MemData,
						C_IRWrite,
						clk, rst);

wire [15:0] MDR_IN, MDR_OUT;

dataMemory DM();
memoryDataRegister MDR(MDR_OUT, MDR_IN, clk);

wire [15:0] D_ReadReg1RT, D_ReadReg2RT;
wire [15:0] D_Offset, D_RegSW;
wire [15:0] D_BT;
wire [15:0] ALUOUT_IN, ALUOUT_OUT;

registerFile RF(D_ReadReg1RT, D_ReadReg2RT,
				D_Offset, D_RegSW,
				D_BT,
				MDR_IN, ALUOUT_OUT,	
				A_ReadReg1RT, A_ReadReg2RT,
				A_Offset, A_RegSWLW,
				A_WriteRegRT_BT,
				C_RegDstWrite, C_RegWrite, C_MemToReg,
				clk, rst);


wire [15:0] ALU_1_IN, ALU_2_IN;
wire ZERO_OUT;

MUXpreALU MPA(ALU_1_IN, ALU_2_IN,
				PC,
				D_ReadReg1RT, D_BT, D_Offset,
				D_ReadReg2RT, D_RegSW,
				D_JUMP_SE_Out , D_SE_Out, D_USE_Out, D_L1S_Out, 
				C_SignExtend,
				C_RegDstRead1R, C_RegDstRead2R,
				C_ALUSrc_A, C_ALUSrc_B);



alu ALU_MAIN(ALUOUT_IN,ZERO_OUT,
				ALU_1_IN,ALU_2_IN,
				ALU_OP);

ALUOut AO(ALUOUT_OUT, ALUOUT_IN, clk);



endmodule
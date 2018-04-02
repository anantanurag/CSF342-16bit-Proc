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



controllerFSM FSM_Main();

programCounter PC();

instructionMemory IM();
instructionRegister IR(OPCODE, FUNCFIELD,
						A_ReadReg1RT, A_ReadReg2RT,
						A_Offset, A_RegSWLW,
						A_WriteRegRT_BT,
						D_MemData,
						C_IRWrite,
						clk, rst);

dataMemory DM();
MemoryDataRegister MDR();

wire [15:0] D_ReadReg1RT, D_ReadReg2RT;
wire [15:0] D_Offset, D_RegSW;
wire [15:0] D_BT;

registerFile RF(D_ReadReg1RT, D_ReadReg2RT,
				D_Offset, D_RegSW,
				D_BT,
				D_MDR_IN, D_ALU_IN,	
				A_ReadReg1RT, A_ReadReg2RT,
				A_Offset, A_RegSWLW,
				A_WriteRegRT_BT,
				C_RegDstWrite, C_RegWrite, C_MemToReg,
				clk, rst);

MUXpreALU MPA(ALU_1_IN, ALU_2_IN,
				PC,
				D_ReadReg1RT, D_BT, D_Offset,
				D_ReadReg2RT, D_RegSW,
				D_JUMP_SE_Out , D_SE_Out, D_USE_Out, D_L1S_Out, 
				C_SignExtend,
				C_RegDstRead1R, C_RegDstRead2R,
				C_ALUSrc_A, C_ALUSrc_B);

alu ALU_MAIN(out,z,
				a,b,
				alu_op);



endmodule
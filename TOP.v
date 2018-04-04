`include "programCounter.v"
`include "MemoryDataRegister.v"
`include "dataMemory.v"
`include "instructionMemory.v"
`include "alu.v"
`include "instructionRegister.v"
`include "MUXpreALU.v"
`include "registerFile.v"
`include "controllerFSM.v"
`include "concat10.v"
`include "concat11.v"
`include "muxPC.v"

module TOP(clk, rst);

	input wire clk, rst;
	wire [15:0] PC;


	wire [1:0] PCSrc;
	wire [2:0] ALU_OP;
	wire sign_extend;
	wire ALUSrcA;
	wire [2:0] ALUSrcB;
	wire [1:0] ReadR1;
	wire ReadR2;
	wire RegWriteDst;
	wire MemToReg;
	wire PCBEqCond, PCBNqCond;
	wire PCWrite;
	wire MemWrite, MemRead;
	wire IRWrite;
	wire RegWrite;

	wire [3:0] OPCODE, FUNCFIELD;

	wire [15:0] PC_OUT;
	wire [15:0] PC_IN;
	wire ZERO_OUT;
	wire PCEnableWrite;
	wire A1_Out;
	wire NZERO;
	wire A2_Out;
	wire O1_Out;
	wire [15:0] D_ReadReg1RT, D_ReadReg2RT;
	wire [15:0] D_Offset, D_RegSW;
	wire [15:0] D_BT;
	wire [15:0] ALUOUT_IN, ALUOUT_OUT;
	wire [15:0] D_Instruction;
	wire [1:0] A_2bit_Offset, A_2bit_RegSWLW;
	wire [3:0] A_Offset, A_RegSWLW;
	wire [3:0] A_ReadReg1RT, A_ReadReg2RT;
	wire [3:0] A_WriteRegRT_BT;
	wire [15:0] IR_InstructionOut;
	wire [15:0] MDR_IN, MDR_OUT;
	wire [15:0] D_WriteData;
	wire [15:0] ALU_1_IN, ALU_2_IN;
	wire [15:0] D_JUMP_SE_Out, D_SE_Out, D_USE_Out, D_L1S_Out;

	controllerFSM FSM_Main(PCSrc, ALU_OP, sign_extend, 
						ALUSrcA ,ALUSrcB, ReadR1, ReadR2, 
						RegWriteDst, MemToReg, PCBEqCond, 
						PCBNqCond, PCWrite, MemWrite, 
						MemRead, IRWrite, RegWrite, 
						OPCODE,FUNCFIELD, clk, rst);

	and A1(A1_Out, ZERO_OUT, PCBEqCond);

	not N1(NZERO, ZERO_OUT);

	and A2(A2_Out, NZERO, PCBNqCond);

	or O1(O1_Out, A1_Out, A2_Out);
	or O2(PCEnableWrite, O1_Out, PCWrite);

	muxPC MPC(PC_IN, ALUOUT_IN, ALUOUT_OUT, D_BT, PCSrc);

	programCounter ProgCount(PC_OUT, PC_IN, PCEnableWrite, clk);

	instructionMemory IM(D_Instruction, PC_OUT, 1'b1, rst);

	concat11 c11(A_RegSWLW, A_2bit_RegSWLW);
	concat10 c10(A_Offset, A_2bit_Offset);

	instructionRegister IR(IR_InstructionOut ,OPCODE, FUNCFIELD,
							A_ReadReg1RT, A_ReadReg2RT,
							A_2bit_Offset, A_2bit_RegSWLW,
							A_WriteRegRT_BT,
							D_Instruction,
							IRWrite,
							clk, rst);

	dataMemory DM(MDR_IN, ALUOUT_OUT, D_RegSW, MemRead, MemWrite, rst);

	memoryDataRegister MDR(MDR_OUT, MDR_IN, clk);

	registerFile RF(D_ReadReg1RT, D_ReadReg2RT,
					D_Offset, D_RegSW,
					D_BT,
					MDR_OUT, ALUOUT_OUT,	
					A_ReadReg1RT, A_ReadReg2RT,
					A_Offset, A_RegSWLW,
					A_WriteRegRT_BT,
					C_RegDstWrite, C_RegWrite, C_MemToReg,
					clk, rst);

	sign_extend_12bto16b se12t16b(D_JUMP_SE_Out, IR_InstructionOut[11:0]);
	sign_extend_8bto16b se8t16b(D_SE_Out, IR_InstructionOut[7:0]);
	unsign_extend_8bto16b use8t16b(D_USE_Out, IR_InstructionOut[7:0]);
	left_1b_shift l1bs(D_L1S_Out, D_SE_Out);

	MUXpreALU MPA(ALU_1_IN, ALU_2_IN,
					PC_OUT,
					D_ReadReg1RT, D_BT, D_Offset,
					D_ReadReg2RT, D_RegSW,
					D_JUMP_SE_Out , D_SE_Out, D_USE_Out, D_L1S_Out, 
					sign_extend,
					ReadR1, ReadR2,
					ALUSrcA, ALUSrcB);

	alu ALU_MAIN(ALUOUT_IN,ZERO_OUT,
					ALU_1_IN,ALU_2_IN,
					ALU_OP);

	ALUOut AO(ALUOUT_OUT, ALUOUT_IN, clk);

endmodule

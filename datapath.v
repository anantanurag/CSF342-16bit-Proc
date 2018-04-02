`include "programCounter.v" 
`include "MemoryDataRegister.v" 
`include "dataMemory.v" 
`include "instructionMemory.v" 
`include "alu.v" 
`include "instructionRegister.v"  
`include "MUXpreALU.v" 
`include "registerFile.v" 
`include "controllerFSM.v"


module datapath(clk, rst);

input clk, rst;

//control signals
wire [1:0] PCSrc;
wire [2:0] ALUOp;
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
wire WriteA, WriteB;
//adding control signal for IM read, need to make changes in controller also
wire IM_Read;

wire [15:0] PC_OUT, PC_IN, I_Data, I_Address;
wire [3:0] OPCODE, FUNCFIELD;
wire [3:0] A_ReadReg1RT, A_ReadReg2RT;
wire [1:0] A_Offset, A_RegSWLW;
wire [3:0] A_WriteRegRT_BT;

wire [15:0] D_MDR_OUT, D_ALU_IN;
wire [15:0] D_ReadReg1RT, D_ReadReg2RT;
wire [15:0] D_Offset, D_RegSW;
wire [15:0] D_BT;

wire [15:0] ALU_1_IN, ALU_2_IN;

reg [15:0] D_JUMP_SE_Out, D_SE_Out, D_USE_Out, D_L1S_Out;

wire [15:0] ALU_out;
wire zero;

wire [15:0] D_Data;


//we can remove write_A and write_B from the controller
controllerFSM FSM_Main(PCSrc, ALUOp, sign_extend, ALUSrcA ,ALUSrcB, ReadR1, ReadR2, RegWriteDst, MemToReg, PCBEqCond, PCBNqCond, PCWrite, MemWrite, MemRead, IRWrite, RegWrite, WriteA, WriteB, OPCODE, FUNCFIELD, clk, rst);

programCounter PC(PC_OUT, PC_IN, PCWrite, clk);
instructionMemory IM(I_Data, I_Address, IM_Read, rst);
instructionRegister IR(OPCODE, FUNCFIELD, A_ReadReg1RT, A_ReadReg2RT, A_Offset, A_RegSWLW, A_WriteRegRT_BT,	I_Data, IRWrite, clk, rst);

//what is the data input to the dataMemory, also, should the DM be clocked?
dataMemory DM(D_Data, ALU_out, D_ReadReg2RT, MemRead, MemWrite, rst);
MemoryDataRegister MDR(D_MDR_OUT, D_Data, clk);

registerFile RF(D_ReadReg1RT, D_ReadReg2RT, D_Offset, D_RegSW, D_BT, D_MDR_OUT, D_ALU_IN, A_ReadReg1RT, A_ReadReg2RT, A_Offset, A_RegSWLW, A_WriteRegRT_BT, RegWriteDst, RegWrite, MemToReg, clk, rst);

alu ALU_MAIN(ALU_out, zero, ALU_1_IN, ALU_2_IN, ALUOp);
MUXpreALU MPA(ALU_1_IN, ALU_2_IN, PC_OUT, D_ReadReg1RT, D_BT, D_Offset,	D_ReadReg2RT, D_RegSW, D_JUMP_SE_Out , D_SE_Out, D_USE_Out, D_L1S_Out, sign_extend, ReadR1, ReadR2, ALUSrcA, ALUSrcB);


endmodule
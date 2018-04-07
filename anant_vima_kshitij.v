/*
	Anant Anurag 2014A3PS0184P
	Vima Gupta 2014A3PS0246P
	Kshitij Khandelwal 2015A3PS0156P
*/
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
	wire RegDstWrite;
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
						RegDstWrite, MemToReg, PCBEqCond, 
						PCBNqCond, PCWrite, MemWrite, 
						MemRead, IRWrite, RegWrite, 
						OPCODE,FUNCFIELD, clk, rst);

	and A1(A1_Out, ZERO_OUT, PCBEqCond);

	not N1(NZERO, ZERO_OUT);

	and A2(A2_Out, NZERO, PCBNqCond);

	or O1(O1_Out, A1_Out, A2_Out);
	or O2(PCEnableWrite, O1_Out, PCWrite);

	muxPC MPC(PC_IN, ALUOUT_IN, ALUOUT_OUT, D_BT, PCSrc);

	programCounter ProgCount(PC_OUT, PC_IN, PCEnableWrite, clk, rst);

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
wire [15:0] memory[15:0];
	registerFile RF(D_ReadReg1RT, D_ReadReg2RT,
					D_Offset, D_RegSW,
					D_BT,
					MDR_OUT, ALUOUT_OUT,	
					A_ReadReg1RT, A_ReadReg2RT,
					A_Offset, A_RegSWLW,
					A_WriteRegRT_BT,
					RegDstWrite, RegWrite, MemToReg,
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

module programCounter(PC_OUT, PC_IN, C_PCWrite, clk, rst);
output reg [15:0] PC_OUT;
input wire [15:0] PC_IN;
input wire C_PCWrite;
input wire clk, rst;

always@(posedge clk)
begin
if(rst == 1'b1)
begin
	PC_OUT <= 16'd0;
end
else begin
	if (C_PCWrite == 1'b1) begin
 		PC_OUT <= PC_IN;
 	end
 	else begin
 		PC_OUT <= PC_OUT;
 	end
end
 	
	
end
endmodule

module memoryDataRegister(MDR_OUT, MDR_IN, clk);
	
	output reg [15:0] MDR_OUT;
	
	input wire [15:0] MDR_IN;
	input wire clk;
	
	always@(posedge clk)
	begin
		MDR_OUT <= MDR_IN;
	end
endmodule

module dataMemory(	D_Data,
					A_DataAddress,
					D_WriteData,
					C_DMRead, C_DMWrite,
					rst
					);

output reg [15:0] D_Data;
input wire [15:0] A_DataAddress;
input wire [15:0] D_WriteData;
input wire C_DMRead, C_DMWrite;
input wire rst;

reg [15:0] memory[0:8192]; // 8192 = 8*1024, 8k*2bytes=16kB
initial $readmemh("data_file.txt", memory);

always @(*) begin
	if (rst == 1) begin
		D_Data = 16'b0000_0000_0000_0000;
	end
	else begin
		if (C_DMWrite == 1) begin
			memory[A_DataAddress] <= D_WriteData;
		end
		// else begin
		// 	memory[A_DataAddress] <= memory[A_DataAddress];
		// end

		if (C_DMRead == 1) begin
			D_Data <= memory[A_DataAddress];
		end
		// else begin
		// 	D_Data <= D_Data;
		// end
	end 
end

endmodule

module instructionMemory(	D_Instruction,
							A_InstrAddress,
							C_IMRead,
							rst
							);

output reg [15:0] D_Instruction;
input wire [15:0] A_InstrAddress;
input wire C_IMRead;
input wire rst;

reg [15:0] memory[0:8192]; // 8192 = 8*1024, 8k*2bytes=16kB
initial $readmemb("instruction_file.txt", memory);

always @(*) begin
	if (rst == 1) begin
		D_Instruction = 16'b0000_0000_0000_0000;		
	end
	else begin
		if (C_IMRead == 1'b1) begin
			D_Instruction = memory[A_InstrAddress];
		end
		// else begin // Dont know what else to do
		// 	memory[A_InstrAddress] = memory[A_InstrAddress];
		// end
	end
end

endmodule

module alu (	out,z,
				a,b,
				alu_op
				);

	output reg [15:0] out;
	output reg z;
	
	input wire [15:0] a,b;
	input wire [2:0] alu_op;

	parameter ADD 	= 3'b000 ;
	parameter SUB 	= 3'b001 ;
	parameter SHR 	= 3'b010 ;// shift right a by b bits
	parameter SHL 	= 3'b011 ;// shift left a by b bits 
	parameter NAND 	= 3'b100 ;
	parameter OR 	= 3'b101 ;
	parameter DIR 	= 3'b110 ;
	parameter SAR	= 3'b111 ;// shift arithmetic right

	always@(*)
	begin
		case(alu_op)
		ADD	:	begin	
					out <= a+b;
					z <= (out==0);
				end
		SUB	: 	begin
					out <= a-b;
					z <= (out==0);
				end
		SHR	:	begin
					out <= a>>b;
					z <= (out==0);
				end
		SHL	:	begin
					out <= a<<b;
					z <= (out==0);
				end
		NAND:	begin
					out <= ~(a&b);
					z <= (out==0);
				end
		OR	:	begin
					out <= a|b;
					z <= (out==0);
				end
		DIR	:	begin
					out <= a;
					z <= (out==0);
				end
		SAR	:	begin
					out <= a>>>b;
					z <= (out==0);
				end
		default:begin
					out <= 16'd0;
					z <= 1'bz;
				end
		endcase
	end

endmodule


module ALUOut(ALUOUT_OUT, ALUOUT_IN, clk);
output reg [15:0] ALUOUT_OUT;
input wire [15:0] ALUOUT_IN;
input wire clk;

always@(posedge clk)
begin
 	ALUOUT_OUT <= ALUOUT_IN;
end
endmodule

module instructionRegister(		D_Instr,
								OPCODE, FUNCFIELD,
								A_ReadReg1RT, A_ReadReg2RT,
								A_Offset, A_RegSWLW,
								A_WriteRegRT_BT,
								D_MemData,
								C_IRWrite,
								clk, rst
								);

	output reg[15:0] D_Instr;
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
				D_Instr <= D_MemData;
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

module MUXpreALU(	ALU_1_IN, ALU_2_IN,
					PC,
					D_ReadReg1RT, D_BT, D_Offset,
					D_ReadReg2RT, D_RegSW,
					D_JUMP_SE_Out , D_SE_Out, D_USE_Out, D_L1S_Out, 
					C_SignExtend,
					C_RegDstRead1R, C_RegDstRead2R,
					C_ALUSrc_A, C_ALUSrc_B
					);

output reg [15:0] ALU_1_IN, ALU_2_IN;

input wire [15:0] PC;
input wire [15:0] D_ReadReg1RT, D_BT, D_Offset;
input wire [15:0] D_ReadReg2RT, D_RegSW;
input wire [15:0] D_JUMP_SE_Out, D_SE_Out, D_USE_Out, D_L1S_Out;

input wire C_SignExtend;
input wire [1:0] C_RegDstRead1R;
input wire C_RegDstRead2R;
input wire C_ALUSrc_A;
input wire [2:0] C_ALUSrc_B;

reg [15:0] M1_Out, M2_Out, M3_Out;

always@(*)
begin
	case(C_RegDstRead1R)
	2'b00 	:	M1_Out <= D_ReadReg1RT;
	2'b01 	:	M1_Out <= D_BT;
	2'b10 	:	M1_Out <= D_Offset;
	default :	M1_Out <= 16'd1;
	endcase	

	case(C_RegDstRead2R)
	1'b0 	:	M2_Out <= D_ReadReg2RT;
	1'b1 	:	M2_Out <= D_RegSW;
	default : 	M2_Out <= 16'd1;
	endcase

	case(C_SignExtend)
	1'b0 	: 	M3_Out <= D_USE_Out;
	1'b1 	: 	M3_Out <= D_SE_Out;
	default :	M3_Out <= 16'd0;
	endcase

	case(C_ALUSrc_A)
	1'b0 	:	ALU_1_IN <= PC;
	1'b1 	: 	ALU_1_IN <= M1_Out;
	default : 	ALU_1_IN <= 16'd1;
	endcase 

	case(C_ALUSrc_B)
	3'b000 	: 	ALU_2_IN <= M2_Out;
	3'b001 	: 	ALU_2_IN <= 2'b01;
	3'b010 	: 	ALU_2_IN <= M3_Out;
	3'b011 	: 	ALU_2_IN <= D_L1S_Out;
	3'b100 	: 	ALU_2_IN <= D_JUMP_SE_Out;
	3'b101 	: 	ALU_2_IN <= D_JUMP_SE_Out[7:4];
	default : 	ALU_2_IN <= 16'd1;
	endcase
end

endmodule

module sign_extend_12bto16b(JUMP_SE_Out, instr11to0);
output wire [15:0] JUMP_SE_Out;
input wire [11:0] instr11to0;
assign JUMP_SE_Out = {{4{instr11to0[11]}}, instr11to0};
endmodule

module sign_extend_8bto16b(SE_Out, instr7to0);
output wire [15:0] SE_Out;
input wire [7:0] instr7to0;
assign SE_Out = {{8{instr7to0[7]}}, instr7to0[7:0]};
endmodule

module unsign_extend_8bto16b(USE_Out, instr7to0);
output wire [15:0] USE_Out;
input wire [7:0] instr7to0;
assign USE_Out = {8'b0000_0000, instr7to0[7:0]};
endmodule

module left_1b_shift(L1S_Out, SE_Out);
output wire [15:0] L1S_Out;
input wire [15:0] SE_Out;
assign L1S_Out = SE_Out << 1'b1;
endmodule

module registerFile(	D_ReadReg1RT, D_ReadReg2RT,
						D_Offset, D_RegSW,
						D_BT,
						D_MDR_IN, D_ALU_IN,	
						A_ReadReg1RT, A_ReadReg2RT,
						A_Offset, A_RegSWLW,
						A_WriteRegRT_BT,
						C_RegDstWrite, C_RegWrite, C_MemToReg,
						clk, rst
						);


output reg [15:0] D_ReadReg1RT, D_ReadReg2RT;
output reg [15:0] D_Offset, D_RegSW;
output reg [15:0] D_BT;

input wire [3:0] A_ReadReg1RT, A_ReadReg2RT;
input wire [3:0] A_Offset, A_RegSWLW;
input wire [3:0] A_WriteRegRT_BT;
input wire [15:0] D_MDR_IN, D_ALU_IN;

input wire C_RegDstWrite, C_RegWrite, C_MemToReg;
input wire clk, rst;

reg [15:0] memory[0:15];
reg [3:0] a_write;
reg [15:0] d_write;

initial 
$readmemh("rf_data.txt",memory);
always@(posedge clk or rst)
begin
		// Selecting Address to write to RF
		if (C_RegDstWrite == 1)
		begin
		a_write = A_WriteRegRT_BT;
		end
		else begin
			a_write = A_RegSWLW;
		end
		// Selecting Data to write to RF
		if (C_MemToReg == 1)
		begin
			d_write = D_MDR_IN;
			//d_write = 16'd7;
		end
		else begin
			d_write = D_ALU_IN;
			//d_write = 16'd7;
		end

		if (C_RegWrite == 1)
		begin
			memory[a_write] = d_write;
		end
		//else begin
		//	a_write = 4'd0;
		//	d_write = 16'd99;
		//end
end
	
always@(posedge clk or rst)
begin
	memory[4'b0000] = 16'b0000_0000_0000_0000;
	if (rst == 0) 
	begin
		D_ReadReg1RT <= memory[A_ReadReg1RT];
		D_ReadReg2RT <= memory[A_ReadReg2RT];
		D_Offset <= memory[A_Offset];
		D_RegSW <= memory[A_RegSWLW];
		D_BT <= memory[A_WriteRegRT_BT];
	end
	//else begin
	//	memory[4'd0] <= 16'd0;
	//	memory[4'd1] <= 16'd0;
	//	memory[4'd2] <= 16'd0;
	//	memory[4'd3] <= 16'd0;
	//	memory[4'd4] <= 16'd0;
	//	memory[4'd5] <= 16'd0;
	//	memory[4'd6] <= 16'd0;
	//	memory[4'd7] <= 16'd0;
	//	memory[4'd8] <= 16'd0;
	//	memory[4'd9] <= 16'd0;
	//	memory[4'd10] <= 16'd0;
	//	memory[4'd11] <= 16'd0;
	//	memory[4'd12] <= 16'd0;
	//	memory[4'd13] <= 16'd0;
	//	memory[4'd14] <= 16'd0;
	//	memory[4'd15] <= 16'd0;
	//end
	
end

endmodule

module controllerFSM(PCSrc, ALUOp, sign_extend, 
					ALUSrcA ,ALUSrcB, ReadR1, ReadR2, 
					RegWriteDst, MemToReg, PCBEqCond, 
					PCBNqCond, PCWrite, MemWrite, 
					MemRead, IRWrite, RegWrite, 
					opcode,func_field, clk, rst);

reg [5:0] NextState, CurrentState;

output reg [1:0] PCSrc;
output reg [2:0] ALUOp;
output reg sign_extend;
output reg ALUSrcA;
output reg [2:0] ALUSrcB;
output reg [1:0] ReadR1;
output reg ReadR2;
output reg RegWriteDst;
output reg MemToReg;
output reg PCBEqCond, PCBNqCond;
output reg PCWrite;
output reg MemWrite, MemRead;
output reg IRWrite;
output reg RegWrite;

input wire [3:0] opcode, func_field;
input wire clk, rst;

parameter I_FETCH = 6'b00_0000;
parameter I_DECODE = 6'b00_0001;

parameter EX_ADD = 6'b00_0010;
parameter EX_ADDI1 = 6'b00_0011;
parameter EX_ADDI2 = 6'b00_0100;
parameter EX_LW_SW = 6'b00_0101;
parameter EX_BEQ = 6'b00_0110;
parameter EX_BNQ = 6'b00_0111;
parameter EX_JMP = 6'b00_1000;
parameter EX_NAND = 6'b00_1001;
parameter EX_NANDI = 6'b00_1010;
parameter EX_OR = 6'b00_1110;
parameter EX_ORI = 6'b00_1111;
parameter EX_SUB = 6'b01_0000;
parameter EX_SUBI1 = 6'b01_0001;
parameter EX_SUBI2 = 6'b01_0010;
parameter EX_SLL = 6'b10_0100;
parameter EX_SRL = 6'b10_0101;
parameter EX_SRA = 6'b10_0110;


parameter MEM_SW = 6'b01_0110;
parameter MEM_LW = 6'b10_0011;
parameter MEM_RTYPE = 6'b10_1000;
parameter WRITEBACK = 6'b11_1111;

parameter OP_ADD = 4'b1000;
parameter OP_ADDI1 = 4'b1001;
parameter OP_ADDI2 = 4'b1010;
parameter OP_SUB = 4'b1100;
parameter OP_SUBI1 = 4'b1101;
parameter OP_SUBI2 = 4'b1110;
parameter OP_SHIFT = 4'b0000;
parameter FF_SHIFT_LEFT_LOGICAL = 4'b0001;
parameter FF_SHIFT_RIGHT_LOGICAL = 4'b0010;
parameter FF_SHIFT_RIGHT_ARITHMETIC = 4'b0011;
parameter OP_NAND = 4'b1011;
parameter OP_NANDI = 4'b0111;
parameter OP_OR = 4'b1111;
parameter OP_ORI = 4'b0110;
parameter OP_BEQ = 4'b0100;
parameter OP_BNQ = 4'b0101;
parameter OP_JMP = 4'b0011;
parameter OP_LW = 4'b0001;
parameter OP_SW = 4'b0010;

// To update the state
// initial
// CurrentState <= I_FETCH;


always @(posedge clk, posedge rst) 
begin
	if (rst) begin
				CurrentState <= I_FETCH;
				// NextState <= I_FETCH;

			end
	else 	 begin CurrentState <= NextState;
	end
end

// To calculate the next state
always@(*)
begin
case(CurrentState)
I_FETCH		:NextState <= I_DECODE;
I_DECODE	:begin
				case(opcode)
				OP_ADD 		:	NextState <= EX_ADD;
				OP_ADDI1	:	NextState <= EX_ADDI1;
				OP_ADDI2  	: 	NextState <= EX_ADDI2;
				OP_SUB 		:	NextState <= EX_SUB;
				OP_SUBI1	:	NextState <= EX_SUBI1;
				OP_SUBI2	:	NextState <= EX_SUBI2;
				OP_SHIFT	:	begin
									if (func_field == FF_SHIFT_LEFT_LOGICAL) begin
										NextState <= EX_SLL;
									end
									else if(func_field == FF_SHIFT_RIGHT_LOGICAL) begin
										NextState <= EX_SRL;
									end
									else if (func_field == FF_SHIFT_RIGHT_ARITHMETIC) begin
										NextState <= EX_SRA;
									end
									else begin
										NextState <= I_FETCH;
									end
								end
				OP_NAND 	:	NextState <= EX_NAND;
				OP_NANDI	:	NextState <= EX_NANDI;
				OP_OR 		:	NextState <= EX_OR;
				OP_ORI 		: 	NextState <= EX_ORI;
				OP_BEQ		:	NextState <= EX_BEQ;
				OP_BNQ		:	NextState <= EX_BNQ;
				OP_JMP		: 	NextState <= EX_JMP;
				OP_LW		: 	NextState <= EX_LW_SW;
				OP_SW		:	NextState <= EX_LW_SW;
				default		: 	NextState <= I_FETCH;
				endcase
			end
EX_ADD 		:NextState <= MEM_RTYPE;
EX_ADDI1	:NextState <= MEM_RTYPE;
EX_ADDI2 	:NextState <= MEM_RTYPE;
EX_SUB 		:NextState <= MEM_RTYPE;
EX_SUBI1 	:NextState <= MEM_RTYPE;
EX_SUBI2	:NextState <= MEM_RTYPE;
EX_SLL		:NextState <= MEM_RTYPE;
EX_SRL		:NextState <= MEM_RTYPE;
EX_SRA		:NextState <= MEM_RTYPE;
EX_NAND 	:NextState <= MEM_RTYPE;
EX_NANDI 	:NextState <= MEM_RTYPE;
EX_OR 		:NextState <= MEM_RTYPE;
EX_ORI		:NextState <= MEM_RTYPE;
EX_BEQ 		:NextState <= I_FETCH;
EX_BNQ		:NextState <= I_FETCH;
EX_JMP		:NextState <= I_FETCH;
EX_LW_SW	:begin
				if (opcode == OP_LW) NextState <= MEM_LW;
				else if (opcode == OP_SW) NextState <= MEM_SW;
				else NextState <= I_FETCH;
			 end
MEM_RTYPE 	:NextState <= I_FETCH;
MEM_SW 		:NextState <= I_FETCH;
MEM_LW 		:NextState <= WRITEBACK;
WRITEBACK	:NextState <= I_FETCH;
default		:NextState <= I_FETCH;
endcase
end
// Output Calculation in MOORE it is only state dependent
always@(*)
begin
case(CurrentState)
I_FETCH		:begin
				PCSrc		<= 2'b00;
				ALUOp		<= 3'b000;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b0;
				ALUSrcB		<= 3'b001;
				ReadR1		<= 2'bxx;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'bx;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b1;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b1;
				RegWrite 	<= 1'b0;
				
			end
I_DECODE	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'bxxx;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b0;
				ALUSrcB		<= 3'b001;
				ReadR1		<= 2'b00;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'bx;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_ADD 		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b000;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b000;
				ReadR1		<= 2'b00;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_ADDI1	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b000;
				sign_extend	<= 1'b1;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b010;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_ADDI2	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b000;
				sign_extend	<= 1'b0;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b010;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_SUB 		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b001;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b000;
				ReadR1		<= 2'b00;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_SUBI1	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b001;
				sign_extend	<= 1'b1;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b010;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_SUBI2	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b001;
				sign_extend	<= 1'b0;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b010;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_SLL		:begin // NOT MADE YET
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b011;
				sign_extend	<= 1'b0;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b101;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_SRL		:begin // NOT MADE YET
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b010;
				sign_extend	<= 1'b0;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b101;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_SRA		:begin // NOT MADE YET
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b111;
				sign_extend	<= 1'b0;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b101;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_NAND		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b100;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b000;
				ReadR1		<= 2'b00;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_NANDI	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b100;
				sign_extend	<= 1'b1;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b010;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_OR		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b101;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b000;
				ReadR1		<= 2'b00;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_ORI		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b101;
				sign_extend	<= 1'b1;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b010;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_BEQ		:begin
				PCSrc		<= 2'b10;
				ALUOp		<= 3'b001;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b000;
				ReadR1		<= 2'b00;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b1;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_BNQ		:begin
				PCSrc		<= 2'b10;
				ALUOp		<= 3'b001;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b000;
				ReadR1		<= 2'b00;
				ReadR2		<= 1'b0;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b1;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_JMP		:begin
				PCSrc		<= 2'b00;
				ALUOp		<= 3'b000;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b0;
				ALUSrcB		<= 3'b100;
				ReadR1		<= 2'bxx;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'bx;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b1;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
EX_LW_SW	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b000;
				sign_extend	<= 1'b1;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b011;
				ReadR1		<= 2'b10;
				ReadR2		<= 1'b1;
				RegWriteDst	<= 1'b0;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'b0;
				PCBNqCond	<= 1'b0;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				end
MEM_RTYPE	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'bxxx;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'bx;
				ALUSrcB		<= 3'bxxx;
				ReadR1		<= 2'bxx;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'b0;
				PCBEqCond	<= 1'bx;
				PCBNqCond	<= 1'bx;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b1;
				
			end
MEM_LW		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'bxxx;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'bx;
				ALUSrcB		<= 3'bxxx;
				ReadR1		<= 2'bxx;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'b0;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'bx;
				PCBNqCond	<= 1'bx;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b1;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
MEM_SW		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'bxxx;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'bx;
				ALUSrcB		<= 3'bxxx;
				ReadR1		<= 2'bxx;
				ReadR2		<= 1'b1;
				RegWriteDst	<= 1'bx;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'bx;
				PCBNqCond	<= 1'bx;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b1;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
WRITEBACK	:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'bxxx;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'bx;
				ALUSrcB		<= 3'bxxx;
				ReadR1		<= 2'bxx;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'b1;
				MemToReg	<= 1'b1;
				PCBEqCond	<= 1'bx;
				PCBNqCond	<= 1'bx;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b1;
				
			end
endcase
end

endmodule

module concat10(c10out, instr10to11);
	
	output wire [3:0] c10out;
	
	input wire [1:0] instr10to11;
	
	assign c10out = {2'b10, instr10to11};

endmodule

module concat11(c11out, instr9to8);

	output wire [3:0] c11out;

	input wire [1:0] instr9to8;

	assign c11out = {2'b11, instr9to8};

endmodule

module muxPC(PC_IN, 
			ALU_result, ALUOut_result, RF_result,
			C_PCSource);

output reg [15:0] PC_IN;
input wire [15:0] ALU_result, ALUOut_result, RF_result;
input wire [1:0] C_PCSource;

always@(*)
begin
	case(C_PCSource)
	2'b00:	PC_IN <= ALU_result;
	2'b01:	PC_IN <= ALUOut_result;
	2'b10:	PC_IN <= RF_result;
	default:PC_IN <= 16'd0;
	endcase
end
endmodule
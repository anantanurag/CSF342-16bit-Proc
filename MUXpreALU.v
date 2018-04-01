`timescale 1ns/10ps
module tb_MUXpreALU();

wire [15:0] ALU_1_IN, ALU_2_IN;

reg [15:0] PC;
reg [15:0] D_ReadReg1RT, D_BT, D_Offset;
reg [15:0] D_ReadReg2RT, D_RegSW;
reg [15:0] D_JUMP_SE_Out, D_SE_Out, D_USE_Out, D_L1S_Out;

reg C_SignExtend;
reg [1:0] C_RegDstRead1R;
reg C_RegDstRead2R;
reg C_ALUSrc_A;
reg [2:0] C_ALUSrc_B;

MUXpreALU uut (ALU_1_IN, ALU_2_IN,
				PC,
				D_ReadReg1RT, D_BT, D_Offset,
				D_ReadReg2RT, D_RegSW,
				D_JUMP_SE_Out , D_SE_Out, D_USE_Out, D_L1S_Out, 
				C_SignExtend,
				C_RegDstRead1R, C_RegDstRead2R,
				C_ALUSrc_A, C_ALUSrc_B);

initial
begin
	#0 PC <= 16'hFFFF;
	#0 D_ReadReg1RT <= 16'hEEEE;
	#0 D_BT <= 16'hDDDD;
	#0 D_Offset <= 16'hCCCC;
	#0 D_ReadReg2RT <= 16'hBBBB;
	#0 D_RegSW <= 16'hAAAA;
	#0 D_JUMP_SE_Out <= 16'h9999;
	#0 D_SE_Out <= 16'h8888;
	#0 D_USE_Out <= 16'h7777;
	#0 D_L1S_Out <= 16'h6666;
end

initial
begin
	#000 C_SignExtend = 1'b0;
	#010 C_SignExtend = 1'b1;
	#010 C_RegDstRead1R = 2'b00;
	#010 C_RegDstRead1R = 2'b01;
	#010 C_RegDstRead1R = 2'b10;
	#010 C_RegDstRead1R = 2'b11;
	#010 C_RegDstRead2R = 1'b0;
	#010 C_RegDstRead2R = 1'b1;
	#010 C_ALUSrc_A = 1'b0;
	#010 C_ALUSrc_A = 1'b1;
	#010 C_ALUSrc_B = 3'b000;
	#010 C_ALUSrc_B = 3'b001;
	#010 C_ALUSrc_B = 3'b010;
	#010 C_ALUSrc_B = 3'b011;
	#010 C_ALUSrc_B = 3'b100;
	#010 C_ALUSrc_B = 3'b101;
	#010 C_ALUSrc_B = 3'b110;
	#010 C_ALUSrc_B = 3'b111;
	#010 $stop;
end

initial
begin
	$dumpfile("MUXpreALU.vcd");
	$dumpvars;
end

initial $monitor("time=%3d, ALU_1_IN=%16h, ALU_2_IN=%16h", $time, ALU_1_IN, ALU_2_IN);


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
	default :	M1_Out <= 16'd0;
	endcase	

	case(C_RegDstRead2R)
	1'b0 	:	M2_Out <= D_ReadReg2RT;
	1'b1 	:	M2_Out <= D_RegSW;
	default : 	M2_Out <= 16'd0;
	endcase

	case(C_SignExtend)
	1'b0 	: 	M3_Out <= D_USE_Out;
	1'b1 	: 	M3_Out <= D_SE_Out;
	default :	M3_Out <= 16'd0;
	endcase

	case(C_ALUSrc_A)
	1'b0 	:	ALU_1_IN <= PC;
	1'b1 	: 	ALU_1_IN <= M1_Out;
	default : 	ALU_1_IN <= 16'd0;
	endcase 

	case(C_ALUSrc_B)
	3'b000 	: 	ALU_2_IN <= M2_Out;
	3'b001 	: 	ALU_2_IN <= 2'b10;
	3'b010 	: 	ALU_2_IN <= M3_Out;
	3'b011 	: 	ALU_2_IN <= D_L1S_Out;
	3'b100 	: 	ALU_2_IN <= D_JUMP_SE_Out;
	default : 	ALU_2_IN <= 16'd0;
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
output wire [7:0] instr7to0;
assign USE_Out = {8'b0000_0000, instr7to0};
endmodule

module left_1b_shift(L1S_Out, SE_Out);
output wire [15:0] L1S_Out;
input wire [15:0] SE_Out;
assign L1S_Out = SE_Out << 1'b1;
endmodule
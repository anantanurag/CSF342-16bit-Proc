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

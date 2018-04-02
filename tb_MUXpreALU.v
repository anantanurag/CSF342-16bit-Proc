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


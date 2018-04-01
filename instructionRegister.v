
module tb_instructionRegister();

	wire [3:0] OPCODE, FUNCFIELD;
	wire [3:0] A_ReadReg1RT, A_ReadReg2RT;
	wire [1:0] A_Offset, A_RegSWLW;
	wire [3:0] A_WriteRegRT_BT;

	reg [15:0] D_MemData;
	reg C_IRWrite;
	reg rst;

	instructionRegister uut(	OPCODE, FUNCFIELD,
								A_ReadReg1RT, A_ReadReg2RT,
								A_Offset, A_RegSWLW,
								A_WriteRegRT_BT,
								D_MemData,
								C_IRWrite,
								rst
								);

	initial
		begin
		#20  D_MemData = 16'b1000_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //add
/*		#20  D_MemData = 16'b1001_1011_11001001; C_IRWrite = 1'b1; rst = 0; //addimex
		#20  D_MemData = 16'b1010_1011_11001001; C_IRWrite = 1'b1; rst = 0; //addimz
		#20  D_MemData = 16'b1100_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //sub
		#20  D_MemData = 16'b1101_1011_11001001; C_IRWrite = 1'b1; rst = 0; //subimex
		#20  D_MemData = 16'b1110_1011_11001001; C_IRWrite = 1'b1; rst = 0; //subimz
		#20  D_MemData = 16'b0000_1011_0100_0001; C_IRWrite = 1'b1; rst = 0; //shl
		#20  D_MemData = 16'b0000_1011_0100_0010; C_IRWrite = 1'b1; rst = 0; //shr
		#20  D_MemData = 16'b0000_1011_0100_0011; C_IRWrite = 1'b1; rst = 0; //sar
		#20  D_MemData = 16'b1011_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //lnandr
		#20  D_MemData = 16'b1111_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //lorr
		#20  D_MemData = 16'b0111_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lnandim
		#20  D_MemData = 16'b0110_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lorim
		#20  D_MemData = 16'b0100_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //be
		#20  D_MemData = 16'b0101_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //bne
		#20  D_MemData = 16'b0011_101101111000; C_IRWrite = 1'b1; rst = 0; //jmp
		#20  D_MemData = 16'b0001_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lw
		#20  D_MemData = 16'b0010_1011_11001001; C_IRWrite = 1'b1; rst = 0; //sw
*/
		#20  C_IRWrite = 1'b0; rst = 0;
		#20  C_IRWrite = 1'b0; rst = 1;
		#20  C_IRWrite = 1'b1; rst = 1;
/*		#20  D_MemData = 16'b1000_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //add
		#20  D_MemData = 16'b1001_1011_11001001; C_IRWrite = 1'b1; rst = 0; //addimex
		#20  D_MemData = 16'b1010_1011_11001001; C_IRWrite = 1'b1; rst = 0; //addimz
		#20  D_MemData = 16'b1100_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //sub
		#20  D_MemData = 16'b1101_1011_11001001; C_IRWrite = 1'b1; rst = 0; //subimex
		#20  D_MemData = 16'b1110_1011_11001001; C_IRWrite = 1'b1; rst = 0; //subimz
		#20  D_MemData = 16'b0000_1011_0100_0001; C_IRWrite = 1'b1; rst = 0; //shl
		#20  D_MemData = 16'b0000_1011_0100_0010; C_IRWrite = 1'b1; rst = 0; //shr
		#20  D_MemData = 16'b0000_1011_0100_0011; C_IRWrite = 1'b1; rst = 0; //sar
		#20  D_MemData = 16'b1011_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //lnandr
		#20  D_MemData = 16'b1111_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //lorr
		#20  D_MemData = 16'b0111_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lnandim
		#20  D_MemData = 16'b0110_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lorim
		#20  D_MemData = 16'b0100_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //be
		#20  D_MemData = 16'b0101_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //bne
		#20  D_MemData = 16'b0011_101101111000; C_IRWrite = 1'b1; rst = 0; //jmp
		#20  D_MemData = 16'b0001_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lw
*/
		#20  D_MemData = 16'b0010_1011_11001001; C_IRWrite = 1'b1; rst = 0; //sw
		#20  $stop;
		end

	initial
		begin
		$dumpfile("instructionRegister.vcd");
		$dumpvars;
		end

endmodule

module instructionRegister(		OPCODE, FUNCFIELD,
								A_ReadReg1RT, A_ReadReg2RT,
								A_Offset, A_RegSWLW,
								A_WriteRegRT_BT,
								D_MemData,
								C_IRWrite,
								rst
								);


	output reg [3:0] OPCODE, FUNCFIELD;
	output reg [3:0] A_ReadReg1RT, A_ReadReg2RT;
	output reg [1:0] A_Offset, A_RegSWLW;
	output reg [3:0] A_WriteRegRT_BT;

	input wire [15:0] D_MemData;
	input wire C_IRWrite;
	input wire rst;

	always@(rst)
	begin
		if (rst == 1) begin
			OPCODE <= 4'b0000;
			FUNCFIELD <= 4'b0000;
			A_ReadReg1RT <= 4'b0000;
			A_ReadReg2RT <= 4'b0000;
			A_Offset <= 4'b0000;
			A_RegSWLW <= 4'b0000;
			A_WriteRegRT_BT <= 4'b0000;
		end
		else begin
			if (C_IRWrite == 1) begin
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
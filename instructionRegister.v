
module tb_instructionRegister();

	wire [3:0] OPCODE, FUNCFIELD;
	wire [3:0] A_ReadReg1RT, A_ReadReg2RT;
	wire [1:0] A_Offset, A_RegSWLW;
	wire [3:0] A_WriteRegRT_BT;

	reg [15:0] D_MemData;
	reg C_IRWrite;
	reg clk, rst;

	instructionRegister uut(	OPCODE, FUNCFIELD,
								A_ReadReg1RT, A_ReadReg2RT,
								A_Offset, A_RegSWLW,
								A_WriteRegRT_BT,
								D_MemData,
								C_IRWrite,
								clk, rst
								);

	initial
	begin
	#00 clk = 1'b0;
	forever #10 clk = ~clk;
	end

	initial
		begin
		#0 rst = 1;
		#17  D_MemData = 16'b1000_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //add
/*		#17  D_MemData = 16'b1001_1011_11001001; C_IRWrite = 1'b1; rst = 0; //addimex
		#17  D_MemData = 16'b1010_1011_11001001; C_IRWrite = 1'b1; rst = 0; //addimz
		#17  D_MemData = 16'b1100_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //sub
		#17  D_MemData = 16'b1101_1011_11001001; C_IRWrite = 1'b1; rst = 0; //subimex
		#17  D_MemData = 16'b1110_1011_11001001; C_IRWrite = 1'b1; rst = 0; //subimz
		#17  D_MemData = 16'b0000_1011_0100_0001; C_IRWrite = 1'b1; rst = 0; //shl
		#17  D_MemData = 16'b0000_1011_0100_0010; C_IRWrite = 1'b1; rst = 0; //shr
		#17  D_MemData = 16'b0000_1011_0100_0011; C_IRWrite = 1'b1; rst = 0; //sar
		#17  D_MemData = 16'b1011_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //lnandr
		#17  D_MemData = 16'b1111_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //lorr
		#17  D_MemData = 16'b0111_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lnandim
		#17  D_MemData = 16'b0110_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lorim
		#17  D_MemData = 16'b0100_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //be
		#17  D_MemData = 16'b0101_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //bne
		#17  D_MemData = 16'b0011_101101111000; C_IRWrite = 1'b1; rst = 0; //jmp
		#17  D_MemData = 16'b0001_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lw
		#17  D_MemData = 16'b0010_1011_11001001; C_IRWrite = 1'b1; rst = 0; //sw
*/		#17  C_IRWrite = 1'b0; rst = 0;
		#17  C_IRWrite = 1'b0; rst = 1;
		#17  C_IRWrite = 1'b1; rst = 1;
/*		#17  D_MemData = 16'b1000_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //add
		#17  D_MemData = 16'b1001_1011_11001001; C_IRWrite = 1'b1; rst = 0; //addimex
		#17  D_MemData = 16'b1010_1011_11001001; C_IRWrite = 1'b1; rst = 0; //addimz
		#17  D_MemData = 16'b1100_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //sub
		#17  D_MemData = 16'b1101_1011_11001001; C_IRWrite = 1'b1; rst = 0; //subimex
		#17  D_MemData = 16'b1110_1011_11001001; C_IRWrite = 1'b1; rst = 0; //subimz
		#17  D_MemData = 16'b0000_1011_0100_0001; C_IRWrite = 1'b1; rst = 0; //shl
		#17  D_MemData = 16'b0000_1011_0100_0010; C_IRWrite = 1'b1; rst = 0; //shr
		#17  D_MemData = 16'b0000_1011_0100_0011; C_IRWrite = 1'b1; rst = 0; //sar
		#17  D_MemData = 16'b1011_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //lnandr
		#17  D_MemData = 16'b1111_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //lorr
		#17  D_MemData = 16'b0111_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lnandim
		#17  D_MemData = 16'b0110_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lorim
		#17  D_MemData = 16'b0100_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //be
		#17  D_MemData = 16'b0101_1011_0100_1000; C_IRWrite = 1'b1; rst = 0; //bne
		#17  D_MemData = 16'b0011_101101111000; C_IRWrite = 1'b1; rst = 0; //jmp
		#17  D_MemData = 16'b0001_1011_11001001; C_IRWrite = 1'b1; rst = 0; //lw
*/
		#17  D_MemData = 16'b0010_1011_11001001; C_IRWrite = 1'b1; rst = 0; //sw
		#17  $stop;
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
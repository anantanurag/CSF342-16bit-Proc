
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
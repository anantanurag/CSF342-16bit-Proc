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
always @(posedge clk or rst) 
begin
	if (rst) begin
				CurrentState <= I_FETCH;
				NextState <= I_FETCH;
			end
	else 	 CurrentState <= NextState;
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
				ALUSrcB		<= 3'b010;
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
				ALUOp		<= 3'b010;
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
EX_SRL		:begin // NOT MADE YET
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b011;
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
EX_SRA		:begin // NOT MADE YET
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b111;
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
EX_NAND		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'b010;
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
				ALUOp		<= 3'b010;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b010;
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
				PCSrc		<= 2'b00;
				ALUOp		<= 3'b001;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b000;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'bx;
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
				PCSrc		<= 2'b00;
				ALUOp		<= 3'b001;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'b1;
				ALUSrcB		<= 3'b000;
				ReadR1		<= 2'b01;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'bx;
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
				PCSrc		<= 2'b01;
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
				RegWriteDst	<= 1'bx;
				MemToReg	<= 1'bx;
				PCBEqCond	<= 1'bx;
				PCBNqCond	<= 1'bx;
				PCWrite		<= 1'b0;
				MemWrite	<= 1'b0;
				MemRead		<= 1'b0;
				IRWrite		<= 1'b0;
				RegWrite 	<= 1'b0;
				
			end
MEM_LW		:begin
				PCSrc		<= 2'bxx;
				ALUOp		<= 3'bxxx;
				sign_extend	<= 1'bx;
				ALUSrcA		<= 1'bx;
				ALUSrcB		<= 3'bxxx;
				ReadR1		<= 2'bxx;
				ReadR2		<= 1'bx;
				RegWriteDst	<= 1'bx;
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
				MemToReg	<= 1'bx;
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

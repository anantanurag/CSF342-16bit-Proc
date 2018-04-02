`timescale 1ns/10ps 
module tb_controllerFSM();
reg [3:0] opcode, func_field;
reg clk, rst;

wire [5:0] NextState, CurrentState;

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

controllerFSM uut (.NextState(NextState), .CurrentState(CurrentState), .PCSrc(PCSrc), .ALUOp(ALUOp), .sign_extend(sign_extend), 
					.ALUSrcA(ALUSrcA) ,.ALUSrcB(ALUSrcB), .ReadR1(ReadR1), .ReadR2(ReadR2), 
					.RegWriteDst(RegWriteDst), .MemToReg(MemToReg), .PCBEqCond(PCBEqCond), 
					.PCBNqCond(PCBNqCond), .PCWrite(PCWrite), .MemWrite(MemWrite), 
					.MemRead(MemRead), .IRWrite(IRWrite), .RegWrite(RegWrite), 
					.WriteA(WriteA), .WriteB(WriteB), 
					.opcode(opcode),.func_field(func_field),.clk(clk),.rst(rst)
					);

initial
begin
	$dumpfile("controllerFSM.vcd");
	$dumpvars;
end

initial
begin
	#0000 clk <= 1'b0;
	forever #5 clk <= ~clk;
end

initial
begin
	#0000 rst = 1'b1;
	#0005 rst = 1'b0;
end

initial
begin
	#0010 opcode <= 1000;
	#0100 $stop;
end

initial
begin
//$monitor("time=%4d, PCSrc=%2b, ALUOp=%3b, sign_extend=%1b,ALUSrcA=%1b ,ALUSrcB=%3b, ReadR1=%2b, ReadR2=%1b, RegWriteDst=%1b, MemToReg=%1b, PCBEqCond=%1b, PCBNqCond=%1b, PCWrite=%1b, MemWrite=%1b, MemRead=%1b, IRWrite=%1b, RegWrite=%1b, WriteA=%1b, WriteB=%1b, opcode=%4b,func_field=%4b, clk=%1b, rst=%1b",$time, PCSrc, ALUOp, sign_extend, ALUSrcA ,ALUSrcB, ReadR1, ReadR2, RegWriteDst, MemToReg, PCBEqCond, PCBNqCond, PCWrite, MemWrite, MemRead, IRWrite, RegWrite, WriteA, WriteB, opcode,func_field, clk, rst);
$monitor("time=%4d, NextState=%6b, CurrentState=%6b, opcode=%4b, func_field=%4b, clk=%b, rst=%b", $time, NextState, CurrentState, opcode, func_field, clk, rst);
end

endmodule


`timescale 1ns/10ps
module tb_instructionMemory();

reg [15:0] A_InstrAddress;
reg C_IMRead, rst;
wire [15:0] D_Instruction;

instructionMemory uut (D_Instruction, A_InstrAddress,C_IMRead,rst);


initial
begin
	#00 rst = 1'b1;
	#30 rst = 1'b0;
end

initial
begin
	#00 C_IMRead = 1'b1;
	#00 A_InstrAddress = 16'd0;
	#100 A_InstrAddress = 16'd1;
	#100 A_InstrAddress = 16'd2;
	#100 $stop;
end

initial
begin
	$dumpfile("instructionMemory.vcd");
	$dumpvars;
end

initial
begin
	$monitor("time=%3d, D_Instruction=%16h, A_InstrAddress=%16h", $time, D_Instruction, A_InstrAddress);
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
initial $readmemh("instruction_file.txt", memory);

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
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
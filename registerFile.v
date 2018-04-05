module registerFile(	D_ReadReg1RT, D_ReadReg2RT,
						D_Offset, D_RegSW,
						D_BT,
						D_MDR_IN, D_ALU_IN,	
						A_ReadReg1RT, A_ReadReg2RT,
						A_Offset, A_RegSWLW,
						A_WriteRegRT_BT,
						C_RegDstWrite, C_RegWrite, C_MemToReg,
						clk, rst
						);


output reg [15:0] D_ReadReg1RT, D_ReadReg2RT;
output reg [15:0] D_Offset, D_RegSW;
output reg [15:0] D_BT;

input wire [3:0] A_ReadReg1RT, A_ReadReg2RT;
input wire [3:0] A_Offset, A_RegSWLW;
input wire [3:0] A_WriteRegRT_BT;
input wire [15:0] D_MDR_IN, D_ALU_IN;

input wire C_RegDstWrite, C_RegWrite, C_MemToReg;
input wire clk, rst;

reg [15:0] memory[0:15];
reg [3:0] a_write;
reg [15:0] d_write;
	
initial 
$readmemh("rf_data.txt",memory);

always@(posedge clk or rst)
begin
	memory[4'b0000] = 16'b0000_0000_0000_0000;
	if (rst == 0) 
	begin
		D_ReadReg1RT <= memory[A_ReadReg1RT];
		D_ReadReg2RT <= memory[A_ReadReg2RT];
		D_Offset <= memory[A_Offset];
		D_RegSW <= memory[A_RegSWLW];
		D_BT <= memory[A_WriteRegRT_BT];

		// Selecting Address to write to RF
		if (C_RegDstWrite == 1)
		begin
		a_write = A_WriteRegRT_BT;
		end
		else begin
			a_write = A_RegSWLW;
		end
		// Selecting Data to write to RF
		if (C_MemToReg == 1)
		begin
			d_write = D_MDR_IN;
		end
		else begin
			d_write = D_ALU_IN;
		end

		if (C_RegWrite == 1)
		begin
			memory[a_write] <= d_write;
		end
		else begin
			a_write = 4'dx;
			d_write = 16'dx;
		end
	end
	/*else begin
		memory[4'd0] <= 16'd0;
		memory[4'd1] <= 16'd0;
		memory[4'd2] <= 16'd0;
		memory[4'd3] <= 16'd0;
		memory[4'd4] <= 16'd0;
		memory[4'd5] <= 16'd0;
		memory[4'd6] <= 16'd0;
		memory[4'd7] <= 16'd0;
		memory[4'd8] <= 16'd0;
		memory[4'd9] <= 16'd0;
		memory[4'd10] <= 16'd0;
		memory[4'd11] <= 16'd0;
		memory[4'd12] <= 16'd0;
		memory[4'd13] <= 16'd0;
		memory[4'd14] <= 16'd0;
		memory[4'd15] <= 16'd0;
	end
	*/
end

endmodule

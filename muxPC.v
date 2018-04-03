module muxPC(PC_IN, 
			ALU_result, ALUOut_result, RF_result,
			C_PCSource);

output reg [15:0] PC_IN;
input wire [15:0] ALU_result, ALUOut_result, RF_result;
input wire [1:0] C_PCSource;

always@(*)
begin
	case(C_PCSource)
	2'b00:	PC_IN <= ALU_result;
	2'b01:	PC_IN <= ALUOut_result;
	2'b10:	PC_IN <= RF_result;
	default:PC_IN <= 16'd0;
	endcase
end
endmodule
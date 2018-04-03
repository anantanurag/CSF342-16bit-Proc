module concat11(c11out, instr9to8);

	output wire [3:0] c11out;

	input wire [1:0] instr9to8;

	assign c11out = {2'b11, instr9to8};

endmodule
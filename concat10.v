module concat10(c10out, instr10to11);
	
	output wire [3:0] c10out;
	
	input wire [1:0] instr10to11;
	
	assign c10out = {2'b10, instr10to11};

endmodule
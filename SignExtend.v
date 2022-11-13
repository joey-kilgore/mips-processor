module SignExtend(in_16, out_32);

	input 	[15:0] in_16;
	output 	[31:0] out_32;
	
	assign out_32 = {{16{in_16[15]}}, in_16};

endmodule
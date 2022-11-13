module MIPS_TB;
	reg clk;
	
	MIPS testMips(clk);

	initial begin
		#100;
	end
	
	always #2 clk = ~clk;
endmodule
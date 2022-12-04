module TopModule(clkin, rst, clk, testReg, PC);
	input clkin, rst;
	output [31:0] testReg;
	output [31:0] PC;
	output clk;
	
	ClockDiv clockDiv(clkin, clk); // use this for board clock
	MIPS mips(clk, rst, testReg, PC);
	
endmodule
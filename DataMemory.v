module DataMemory(clk, address, writeData, memWrite, memRead, readData);
	input						clk;
	input 		[31:0] 	address, writeData;
	input 					memWrite, memRead;
	output reg	[31:0]	readData;
	
	parameter depth = 1024;
	reg [31:0] data [0:depth-1];

	// Writing on positive edge
	always @(posedge clk) begin
		if(memWrite) data[address] <= writeData;
		else data[address] <= data[address];
	end

	// Reading on negative edge
	always @(negedge clk) begin
		if(memRead) readData <= data[address];
		else readData <= readData;
	end

endmodule
module DataMemory(clk, rst, address, writeData, memWrite, memRead, readData);
	input						clk, rst;
	input 		[31:0] 	address, writeData;
	input 					memWrite, memRead;
	output reg	[31:0]	readData;
	
	parameter DEPTH = 1024;
	reg [31:0] data [0:DEPTH-1];
	
	integer i;
	
	// Writing on positive edge and SYNC reset
	always @(posedge clk) begin
		if(!rst) begin
			if(memWrite) data[address] <= writeData;
			else data[address] <= data[address];
		end
		else begin
			for (i=0; i<DEPTH; i=i+1) data[i] <= 0;
		end
	end

	// Reading on negative edge and SYNC reset
	always @(negedge clk) begin
		if(!rst) begin
			if(memRead) readData <= data[address];
			else readData <= readData;
		end
		else begin
			readData <= 0;
		end
	end

endmodule
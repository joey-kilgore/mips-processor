module DataMemory(clk, address, writeData, memWrite, memRead, readData);
	input clk;
	input [31:0] address, writeData;
	input memWrite, memRead;
	output reg [31:0] readData;

	reg outMemAddress;
	reg [31:0] memToCacheData, cacheToMemData;
	reg readMem, writeMem, dataGrabbed, memDataReady;

	DataCache dataCache(clk, address, outMemAddress, writeData, memToCacheData, memRead, cacheToMemData, memRead, memWrite, readMem, writeMem, dataGrabbed, memDataReady);
	MainMemory MainMemory(outMemAddress, cacheToMemData, writeMem, readMem, memToCacheData);
endmodule
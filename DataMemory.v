module DataMemory(clk, rst, address, writeData, memWrite, memRead, readData);
	input clk, rst;
	input reg [31:0] address, writeData;
	input reg memWrite, memRead;
	output reg [31:0] readData;

	reg outMemAddress;
	reg [31:0] memToCacheData, cacheToMemData;
	reg readMem, writeMem, dataGrabbed, memDataReady;

	DataCache dataCache(clk, rst, address, outMemAddress, writeData, memToCacheData, memRead, cacheToMemData, memRead, memWrite, readMem, writeMem, dataGrabbed, memDataReady);
	MainMemory MainMemory(rst, outMemAddress, cacheToMemData, writeMem, readMem, memToCacheData);
endmodule
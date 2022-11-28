module DataMemory(clk, rst, address, writeData, memWrite, memRead, readData);
	input clk, rst;
	input [31:0] address, writeData;
	input memWrite, memRead;
	output [31:0] readData;

	wire [31:0] outMemAddress;
	wire [31:0] memToCacheData, cacheToMemData;
	wire readMem, writeMem, dataGrabbed, memDataReady;

	DataCache dataCache(clk, rst, address, outMemAddress, writeData, memToCacheData, readData, cacheToMemData, memRead, memWrite, readMem, writeMem, dataGrabbed, memDataReady);
	MainMemory mainMemory(rst, outMemAddress, cacheToMemData, writeMem, readMem, memToCacheData, dataGrabbed, memDataReady);
endmodule

`timescale 1ns/1ns
module Cache_TB;
	reg clk, rst;
	reg [31:0] address, writeData;
	reg memWrite, memRead;
	wire [31:0] readData;
	wire dataReady;
	
	DataMemory dataMemory(clk, rst, address, writeData, memWrite, memRead, readData, dataReady);

    wire[31:0] addr0, addr1, cache0;
    assign addr0 = dataMemory.mainMemory.data[32'h0000_0000];
    assign addr1 = dataMemory.mainMemory.data[32'h0000_0100];
    assign cache0 = dataMemory.dataCache.data[0];

	initial begin
        clk <= 1'b0;
        address <= 32'b0;
        writeData <= 32'b0;
        memWrite <= 1'b0;
        memRead <= 1'b0;
        rst <= 1'b0;

        #5
        rst <= 1'b1;

        #4
        rst <= 1'b0;
        address <= 32'h0000_0000;
        writeData <= 32'hF0F0_F0F0;
        memWrite <= 1'b1;

        #4
        memWrite <= 1'b0;
        memRead <= 1'b1;
        
        #4
        memRead <= 1'b0;

        #4
        address <= 32'h0000_0100;
        writeData <= 32'h0000_0001;
        memWrite <= 1'b1;

        #4
        memWrite <= 1'b0;
        memRead <= 1'b1;

        #4
        memRead <= 1'b0;

        #4
        address <= 32'h0000_0000;
        memRead <= 1'b1;

        #4
        memRead <= 1'b0;

		#12 $stop;
		$finish;
	end
	
	always #2 clk = ~clk;

//    initial
//    begin
//    $shm_open("mywave.db");
//    $shm_probe(Cache_TB,"AS");
//    $shm_save;
//    end
endmodule

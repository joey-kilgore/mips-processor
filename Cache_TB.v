module Cache_TB;
	reg clk, rst;
	reg [31:0] address, writeData;
	reg memWrite, memRead;
	reg [31:0] readData;
	
	DataMemory dataMemory(clk, rst, address, writeData, memWrite, memRead, readData);


	initial begin
        clk <= 1'b0;
        address <= 32'b0;
        writeData <= 32'b0;
        memWrite <= 1'b0;
        memRead <= 1'b0;

        #5
        rst <= 1'b1;

        #4
        rst <= 1'b0;
        address <= 32'h0000_0000;
        writeData <= 32'hF0F0_F0F0;
        memWrite <= 1'b1;

        #4
        memWrite <= 1'b0;
        
        #4
        memRead <= 1'b0;

        #4
        rst <= 1'b0;
        address <= 32'h0000_0100;
        writeData <= 32'h0000_0001;
        memWrite <= 1'b1;

        #4
        memWrite <= 1'b0;
        
        #4
        memRead <= 1'b0;

		#12 $finish;
	end
	
	always #2 clk = ~clk;

    initial
    begin
    $shm_open("mywave.db");
    $shm_probe(MIPS_TB,"AS");
    $shm_save;
    end
endmodule

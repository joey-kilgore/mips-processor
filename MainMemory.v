module MainMemory(rst, address, inData, memWrite, memRead, outData, dataGrabbed, memDataReady);
    input rst, memRead, memWrite, dataGrabbed;
    input [31:0] address, inData;
    output reg[31:0] outData;
    output reg memDataReady;
    integer i;
	
    // due to limitations we are only going to have a 
    // 10-bit address space
	parameter depth = 1024;
	reg [31:0] data [0:depth-1];

    always @(posedge rst) begin
        for(i=0;i<depth;i=i+1) begin data[i]<=0; end
        memDataReady <= 1'b0;
        outData <= 32'h0000_0000;
    end

	always @(posedge memWrite) begin
        data[address[9:0]] <= inData;
    end

    always @(posedge memRead) begin
        outData <= data[address[9:0]];
        memDataReady <= 1'b1;
    end

    always @(posedge dataGrabbed) begin
        memDataReady <= 1'b0;
    end
endmodule

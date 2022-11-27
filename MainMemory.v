module MainMemory(rst, address, writeData, memWrite, memRead, readData);
    input readMem, writeMem dataGrabbed;
    input reg[31:0] address, inData;
    output reg[31:0] outData;
    output memDataReady;
    integer i;
	
    // due to limitations we are only going to have a 
    // 10-bit address space
	parameter depth = 1024;
	reg [31:0] data [0:depth-1];
    reg [9:0] index;
    assign index = address[9:0];

    always @(posedge rst) begin
        for(i=0;i<depth;i=i+1) begin data[i]<=0; end
    end

	always @(posedge writeMem) begin
        data[index] <= inData;
    end

    always @(posedge readMem) begin
        outData <= data[index];
        memDataReady <= 1'b1;
    end

    always @(posedge dataGrabbed) begin
        memDataReady <= 1'b0;
    end
endmodule
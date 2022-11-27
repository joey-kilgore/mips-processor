module DataCache(clk, inPipeAddress, outMemAddress, inPipeData, inMemData, outPipeData, outMemData, readPipe, writePipe, readMem, writeMem, dataGrabbed, memDataReady);
    // data cache interacts with both the pipeline 'DataMemory'
    //  and the 'MainMemory'
    // to avoid confusion pipeline connections are noted as 'pipe'
    //  and main memory connections are noted as 'mem'
    // additionally some lines are inputs and outputs of the cache
    //  these are noted with the in and out prefix
    input clk;
    input reg [31:0] inPipeAddress;
    output reg [31:0] outMemAddress;
    input reg [31:0] inPipeData, inMemData;
    output reg [31:0] outPipeData, outMemData;
    input reg readPipe, writePipe;
    output reg readMem, writeMem dataGrabbed;
    input reg memDataReady;
    reg miss;

    // the cache is 256 entries which requires an
    //  8-bit index for a direct mapped cache
    // the remaining 24 bits of the address are needed to check
    //  the tag of the data to ensure the correct data is
    //  grabbed
    // note that we are using a write through policy meaning that
    //  all writes to cache are also immediately written
    //  back to the main memory so that the cache is always consistent
    //  with main memory and no dirty/valid flags are needed
    parameter depth = 256; // 8-bit tag
    reg [31:0] data[0:depth-1];
    reg [23:0] dataTags[0:depth-1];
    reg [7:0] index;
    reg [23:0] tag;
    assign index = inPipeAddress[7:0];
    assign tag = inPipeAddress[31:8];

    always@(posedge clk) begin
        outMemAddress <= 32'b0;
        outPipeData <= 32'b0;
        outMemData <= 32'b0;
        readMem <= 1'b0;
        writeMem <= 1'b0;
        dataGrabbed <= 1'b0;

        if(writePipe) begin
            // because we have a write-through policy
            //  we can just write over any data in the
            //  cache without any extra steps
            data[index] <= inPipeData;
            dataTags[index] <= tag;
            writeMem <= 1'b1;
            outMemAddress <= inPipeAddress;
            outMemData <= inPipeData;
        end
    end

    always@(negedge clk) begin
        // reading from the cache
        if(readPipe) begin
            if(dataTags[index] == tag) begin
                // cache hit!
                outPipeData <= data[index];
            end
            else begin
                // cache miss
                outMemAddress <= inPipeAddress;
                readMem <= 1'b1;
                miss <= 1'b1;
            end
        end
    end

    always@(posedge memDataReady) begin
        if(miss == 1'b1) begin
            miss <= 1'b0;
            data[index] <= inMemData;
            dataTags[index] <= tag;
            outPipeData <= inMemData;   
            dataGrabbed <= 1'b1;
        end
    end
endmodule
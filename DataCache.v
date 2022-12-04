module DataCache(clk, rst, inPipeAddress, outMemAddress, inPipeData, inMemData, outPipeData, outMemData, readPipe, writePipe, readMem, writeMem, dataGrabbed, memDataReady, miss);
    // data cache interacts with both the pipeline 'DataMemory'
    //  and the 'MainMemory'
    // to avoid confusion pipeline connections are noted as 'pipe'
    //  and main memory connections are noted as 'mem'
    // additionally some lines are inputs and outputs of the cache
    //  these are noted with the in and out prefix
    input clk, rst;
    input [31:0] inPipeAddress;
    output reg [31:0] outMemAddress;
    input [31:0] inPipeData, inMemData;
    output reg [31:0] outPipeData, outMemData;
    input readPipe, writePipe;
    output reg readMem, writeMem, dataGrabbed;
    input memDataReady;
    output reg miss;
    integer i;

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
    wire [7:0] index;
    wire [23:0] tag;
    assign index = inPipeAddress[7:0];
    assign tag = inPipeAddress[31:8];

    always@(negedge clk) begin
        if(rst) begin
            for(i=0;i<depth;i=i+1) begin 
                data[i]<=32'hFFFF_FFFF;
                // because the memory space is limited these
                //  memory tags are beyond the memory space at
                //  initialization so that the cache is starting
                //  with a blank state
                dataTags[i]<=24'hFF_FF_FF;   
            end
            outMemAddress <= 32'b0;
            outPipeData <= 32'b0;
            outMemData <= 32'b0;
            readMem <= 1'b0;
            writeMem <= 1'b0;
            dataGrabbed <= 1'b0;
            miss <= 1'b0;
        end
		  else if(memDataReady==1'b1 && miss==1'b1) begin
				// data is ready from memory
				miss <= 1'b0;
            data[index] <= inMemData;
            dataTags[index] <= tag;
            outPipeData <= inMemData;   
            dataGrabbed <= 1'b1;
		  end
        else if(writePipe) begin
            // because we have a write-through policy
            //  we can just write over any data in the
            //  cache without any extra steps
            data[index] <= inPipeData;
            dataTags[index] <= tag;
            outMemAddress <= inPipeAddress;
            outMemData <= inPipeData;
            writeMem = 1'b1;
            outPipeData <= 32'b0;
            readMem <= 1'b0;
            dataGrabbed <= 1'b0;
        end

        // reading from the cache
        else if(readPipe) begin
            if(dataTags[index] == tag) begin
                // cache hit!
                outPipeData <= data[index];
                            
                outMemAddress <= 32'b0;
                outMemData <= 32'b0;
                readMem <= 1'b0;
                writeMem <= 1'b0;
                dataGrabbed <= 1'b0;
            end
            else begin
                // cache miss
                outMemAddress <= inPipeAddress;
                readMem <= 1'b1;
                miss <= 1'b1;

                outPipeData <= 32'b0;
                outMemData <= 32'b0;
                writeMem <= 1'b0;
                dataGrabbed <= 1'b0;
            end
        end
    end
endmodule

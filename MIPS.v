module MIPS(clk, rst);

	input clk, rst;
	parameter DATA_DEPTH = 1024;
	parameter INST_DEPTH = 1024;

	reg [31:0] instMem [0:INST_DEPTH-1];
	reg [31:0] PC;
	
	reg [31:0]  inst;
	wire [5:0]	opCode;
	wire [4:0]	rs;
	wire [4:0]	rt;
	wire [4:0]	rd;
	wire [4:0] 	shamt;
	wire [5:0] 	funct;
	wire [15:0] immed;
	wire [25:0] address;

	wire [4:0] writeReg;
	wire [31:0] writeDataReg, readData1, readData2, out_32, input2;
	reg [31:0] input1;
	wire [31:0] aluResult;
	reg [31:0] dataAddress, writeData;
	wire [31:0] readData;
	wire [1:0] aluOp;
	wire [3:0] aluControl;

	assign opCode 	= inst[31:26];
	assign rs 		= inst[25:21];
	assign rt 		= inst[20:16];
	assign rd 		= inst[15:11];
	assign shamt 	= inst[10:6];
	assign funct 	= inst[5:0];
	assign immed 	= inst[15:0];
	assign address = inst[25:0];	

	RegFile			mipsRegFile(clk, rst, regWrite, rs, rt, writeReg, readData1, readData2, writeDataReg);
	ControlUnit		mipsControlUnit(opCode, regDst, jump, branch, memRead, memToReg, aluOp, memWrite, aluSrc, regWrite);
	SignExtend 		mipsSignExtend(immed, out_32);
	ALU 				mipsALU(input1, input2, aluControl, shamt, aluResult, zero);
	DataMemory 		mipsDataMemory(clk, rst, dataAddress, writeData, memWrite, memRead, readData);
	ALUControlUnit mipsALUControlUnit(funct, aluOp, aluControl);
	Mux5 				writeRegMux(rt, rd, regDst, writeReg);
	Mux 				aluMux(readData2, out_32, aluSrc, input2);
	Mux 				memMux(aluResult, readData, memToReg, writeDataReg);
	//Mux 				branchMux(D0, D1, S, Y);
	//Mux 				jumpMux(D0, D1, S, Y);
	
	// Fetch inst on negative edge
	always @(negedge clk) begin
		if(!rst) inst <= instMem[PC];
		else		inst <= inst;
	end
	always @(posedge clk) begin
		if(!rst) PC <= PC + 1;
		else		PC <= 0;
	end
	
	always @(readData1)begin input1 <= readData1; end
	always @(aluResult)begin dataAddress <= aluResult; end
	always @(readData2)begin writeData <= readData2; end

endmodule

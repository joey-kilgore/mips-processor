module MIPS(clk);

	input clk;
	parameter DATA_DEPTH = 1024;
	parameter INST_DEPTH = 1024;

	reg [31:0] instMem [0:INST_DEPTH-1];
	reg [31:0] PC;
	
	wire [5:0]	opCode;
	wire [4:0]	rs;
	wire [4:0]	rt;
	wire [4:0]	rd;
	wire [4:0] 	shamt;
	wire [5:0] 	funct;
	wire [15:0] immed;
	wire [25:0] address;
	
	assign opCode 	= instMem[PC][31:26];
	assign rs 		= instMem[PC][25:21];
	assign rt 		= instMem[PC][20:16];
	assign rd 		= instMem[PC][15:11];
	assign shamt 	= instMem[PC][10:6];
	assign funct 	= instMem[PC][5:0];
	assign immed 	= instMem[PC][15:0];
	assign address = instMem[PC][25:0];
	
	
	RegFile			mipsRegFile(clk, writeEnb, readReg1, readReg2, writeReg, readData1, readData2, writeData);
	ControlUnit		mipsControlUnit(opCode, regDst, jump, branch, memRead, memToReg, aluOp, memWrite, aluSrc, regWrite);
	SignExtend 		mipsSignExtend(in_16, out_32);
	ALU 				mipsALU(input1, input2, aluControl, shamt, aluResult, zero);
	DataMemory 		mipsDataMemory(clk, address, writeData, memWrite, memRead, readData);
	ALUControlUnit mipsALUControlUnit(funct, aluOp, aluControl);
	Mux 				writeRegMux(D0, D1, S, Y);
	Mux 				aluMux(D0, D1, S, Y);
	Mux 				memMux(D0, D1, S, Y);
	Mux 				branchMux(D0, D1, S, Y);
	Mux 				jumpMux(D0, D1, S, Y);


endmodule
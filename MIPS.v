module MIPS(clk, rst);

	input clk, rst;
	parameter DATA_DEPTH = 1024;
	parameter INST_DEPTH = 1024;

	reg [31:0] instMem [0:INST_DEPTH-1];
	reg [31:0] PC;
	
	reg [31:0]  inst;
	wire [5:0]	opCode;
	wire [4:0]	IF_ID_rs;
	wire [4:0]	IF_ID_rt;
	wire [4:0]	IF_ID_rd;
	wire [4:0] 	IF_ID_shamt;
	wire [5:0] 	IF_ID_funct;
	wire [15:0] immed;
	wire [25:0] address;

	wire [4:0] writeReg;
	wire [31:0] writeData, readData1, readData2, immed_32, input2;
	reg [31:0] input1;
	wire [31:0] aluResult;
	reg [31:0] dataAddress;
	wire [31:0] readData;
	wire [1:0] aluOp;
	wire [3:0] aluControl;
	wire dataReady;



	
	// Pipeline registers
	reg [31:0] 	IF_ID_PC;
	reg [31:0] 	IF_ID_inst;
	
	reg 			ID_EX_regDst, ID_EX_jump, ID_EX_branch, ID_EX_memRead, ID_EX_memToReg, ID_EX_memWrite, ID_EX_aluSrc, ID_EX_regWrite;
	reg [1:0]	ID_EX_aluOp;
	reg [31:0]	ID_EX_PC;
	reg [31:0] 	ID_EX_readData1;
	reg [31:0] 	ID_EX_readData2;
	reg [4:0]  	ID_EX_rs;
	reg [4:0]  	ID_EX_rt;
	reg [4:0]  	ID_EX_rd;
	reg [4:0] 	ID_EX_shamt;	
	reg [5:0]  	ID_EX_funct;
	reg [31:0] 	ID_EX_immed_32; 

	reg 			EX_MEM_branch, EX_MEM_memRead, EX_MEM_memToReg, EX_MEM_memWrite, EX_MEM_regWrite;
	reg [4:0]  	EX_MEM_writeReg;
	reg [31:0] 	EX_MEM_aluResult;
	reg 			EX_MEM_zero;
	reg [31:0] 	EX_MEM_readData2;
	reg [31:0] 	EX_MEM_branchAdd;

	reg 			MEM_WB_memToReg, MEM_WB_regWrite;	
	reg [4:0]  	MEM_WB_writeReg;
	reg [31:0]	MEM_WB_aluResult;
	reg [31:0]	MEM_WB_readData;

	assign opCode 	= IF_ID_inst[31:26];
	assign IF_ID_rs 		= IF_ID_inst[25:21];
	assign IF_ID_rt 		= IF_ID_inst[20:16];
	assign IF_ID_rd 		= IF_ID_inst[15:11];
	assign IF_ID_shamt 	= IF_ID_inst[10:6];
	assign IF_ID_funct 	= IF_ID_inst[5:0];
	assign immed 	= IF_ID_inst[15:0];
	assign address = IF_ID_inst[25:0];	
	
	
	//reg [4:0]EXMEMrt,EXMEMrs;
	//reg [4:0]MEMWBrt,MEMWBrs;
//	reg [11:0]EXMEMControlLines;
//	reg [4:0]EXEMEMWriteReg;
	//reg EXEMEMoverflow;
	//reg MEMWBoverflow;
	//reg [11:0]MEMWBControlLines;
	
	RegFile			mipsRegFile(clk, rst, MEM_WB_regWrite, IF_ID_rs, IF_ID_rt, MEM_WB_writeReg, readData1, readData2, writeData);
	ControlUnit		mipsControlUnit(opCode, regDst, jump, branch, memRead, memToReg, aluOp, memWrite, aluSrc, regWrite);
	SignExtend 		mipsSignExtend(immed, immed_32);
	ALU 				mipsALU(ID_EX_readData1, input2, aluControl, ID_EX_shamt, aluResult, zero);
	DataMemory 		mipsDataMemory(clk, rst, EX_MEM_aluResult, EX_MEM_readData2, EX_MEM_memWrite, EX_MEM_memRead, readData, dataReady);
	ALUControlUnit mipsALUControlUnit(ID_EX_funct, ID_EX_aluOp, aluControl);
	Mux #(.WIDTH(5)) writeRegMux(ID_EX_rt, ID_EX_rd, ID_EX_regDst, writeReg);
	Mux 				aluMux(ID_EX_readData2, ID_EX_immed_32, ID_EX_aluSrc, input2);
	Mux 				memMux(MEM_WB_aluResult, MEM_WB_readData, MEM_WB_memToReg, writeData);
	//Mux 				branchMux(D0, D1, S, Y);
	//Mux 				jumpMux(D0, D1, S, Y);
	
	// Fetch inst on negative edge
	always @(negedge clk) begin
		if(rst) 	inst <= inst;
		else if(dataReady == 1'b1) inst <= inst;
		else		inst <= instMem[PC];
	end
	always @(posedge clk) begin
		if(rst) 	PC <= 0;
		else if(dataReady == 1'b1) PC <= PC;
		else		PC <= PC + 1;
	end
	
	// Update pipeline registers
	always @(posedge clk) begin
		if(rst) begin 
			IF_ID_PC 			<= 0;
			IF_ID_inst 			<= 0;

			ID_EX_regDst 		<= 0;
			ID_EX_jump			<= 0;
			ID_EX_branch		<= 0;
			ID_EX_memRead		<= 0;
			ID_EX_memToReg		<= 0;
			ID_EX_memWrite		<= 0;
			ID_EX_aluSrc		<= 0;
			ID_EX_regWrite		<= 0;
			ID_EX_aluOp			<= 0;
			ID_EX_PC				<= 0;
			ID_EX_readData1	<= 0;
			ID_EX_readData2	<= 0;
			ID_EX_rs				<= 0;
			ID_EX_rt 			<= 0;
			ID_EX_rd				<= 0;
			ID_EX_shamt			<= 0;
			ID_EX_funct			<= 0;
			ID_EX_immed_32		<= 0;

			EX_MEM_branch		<= 0;
			EX_MEM_memRead 	<= 0;
			EX_MEM_memToReg	<= 0;
			EX_MEM_memWrite	<= 0;
			EX_MEM_regWrite	<= 0;
			EX_MEM_writeReg	<= 0;
			EX_MEM_aluResult	<= 0;
			EX_MEM_zero			<= 0;
			EX_MEM_readData2	<= 0;
			EX_MEM_branchAdd	<= 0;

			MEM_WB_memToReg	<= 0;
			MEM_WB_regWrite	<= 0;
			MEM_WB_writeReg	<= 0;
			MEM_WB_aluResult	<= 0;
			MEM_WB_readData	<= 0;
		end
		else if(dataReady == 1'b1) begin
			IF_ID_PC 			<= IF_ID_PC;
			IF_ID_inst 			<= IF_ID_inst;

			ID_EX_regDst 		<= ID_EX_regDst;
			ID_EX_jump			<= ID_EX_jump;
			ID_EX_branch		<= ID_EX_branch;
			ID_EX_memRead		<= ID_EX_memRead;
			ID_EX_memToReg		<= ID_EX_memToReg;
			ID_EX_memWrite		<= ID_EX_memWrite;
			ID_EX_aluSrc		<= ID_EX_aluSrc;
			ID_EX_regWrite		<= ID_EX_regWrite;
			ID_EX_aluOp			<= ID_EX_aluOp;
			ID_EX_PC				<= ID_EX_PC;
			ID_EX_readData1	<= ID_EX_readData1;
			ID_EX_readData2	<= ID_EX_readData2;
			ID_EX_rs				<= ID_EX_rs;
			ID_EX_rt 			<= ID_EX_rt;
			ID_EX_rd				<= ID_EX_rd;
			ID_EX_shamt			<= ID_EX_shamt;
			ID_EX_funct			<= ID_EX_funct;
			ID_EX_immed_32		<= ID_EX_immed_32;
                             
			EX_MEM_branch		<= EX_MEM_branch;
			EX_MEM_memRead 	<= EX_MEM_memRead;
			EX_MEM_memToReg	<= EX_MEM_memToReg;
			EX_MEM_memWrite	<= EX_MEM_memWrite;
			EX_MEM_regWrite	<= EX_MEM_regWrite;
			EX_MEM_writeReg	<= EX_MEM_writeReg;
			EX_MEM_aluResult	<= EX_MEM_aluResult;
			EX_MEM_zero			<= EX_MEM_zero;
			EX_MEM_readData2	<= EX_MEM_readData2;
			EX_MEM_branchAdd	<= EX_MEM_branchAdd;
                             
			MEM_WB_memToReg	<= MEM_WB_memToReg;
			MEM_WB_regWrite	<= MEM_WB_regWrite;
			MEM_WB_writeReg	<= MEM_WB_writeReg;
			MEM_WB_aluResult	<= MEM_WB_aluResult;
			MEM_WB_readData	<= MEM_WB_readData;
		end
		else begin
			IF_ID_PC 			<= PC;
			IF_ID_inst 			<= inst;
	
			ID_EX_regDst 		<= regDst; 	
			ID_EX_jump			<= jump;		
			ID_EX_branch		<= branch;	
			ID_EX_memRead		<= memRead;	
			ID_EX_memToReg		<= memToReg;	
			ID_EX_memWrite		<= memWrite;	
			ID_EX_aluSrc		<= aluSrc;	
			ID_EX_regWrite		<= regWrite;	
			ID_EX_aluOp			<= aluOp;		
			ID_EX_PC				<= IF_ID_PC;
			ID_EX_readData1	<= readData1;
			ID_EX_readData2	<= readData2;
			ID_EX_rs				<= IF_ID_rs;
			ID_EX_rt 			<= IF_ID_rt;
			ID_EX_rd				<= IF_ID_rd;
			ID_EX_shamt			<= IF_ID_shamt;	
			ID_EX_funct			<= IF_ID_funct;
			ID_EX_immed_32		<= immed_32;

			EX_MEM_branch		<= ID_EX_branch;	
			EX_MEM_memRead 	<= ID_EX_memRead;	
			EX_MEM_memToReg	<= ID_EX_memToReg;
			EX_MEM_memWrite	<= ID_EX_memWrite;
			EX_MEM_regWrite	<= ID_EX_regWrite;
			EX_MEM_writeReg	<= writeReg;
			EX_MEM_aluResult	<= aluResult;
			EX_MEM_zero			<= zero;
			EX_MEM_readData2	<= ID_EX_readData2;
			EX_MEM_branchAdd	<= ID_EX_PC + ID_EX_immed_32;

			MEM_WB_memToReg	<= EX_MEM_memToReg;
			MEM_WB_regWrite	<= EX_MEM_regWrite;
			MEM_WB_writeReg	<= EX_MEM_writeReg;
			MEM_WB_aluResult	<= EX_MEM_aluResult;
			MEM_WB_readData	<= readData;	
			
		end
	end
	
//	always @(readData1)begin input1 <= ID_EX_readData1; end
//	always @(shamt)begin input1 <= ID_EX_readData1; end
//	always @(aluResult)begin dataAddress <= aluResult; end
//	always @(readData2)begin writeData <= readData2; end

endmodule

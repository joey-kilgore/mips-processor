module RegFile(clk, writeEnb, readReg1, readReg2, writeReg, readData1, readData2, writeData);

	input [4:0] 	readReg1; 	//Address of first regfile operand
	input [4:0] 	readReg2; 	//Address of second regfile operand
	input [4:0] 	writeReg; 	//Address of reg that we want to write in (in case of lw,R-Format instructions)
	input [31:0] 	writeData; 	//Data to be written in (in case of lw,R-Format instructions)
	input wire 		writeEnb;	//Write enable signal of  Regfile 
	input wire 		clk;			//Clk signal
	
	output  [31:0] readData1; //First output of regfile
	output  [31:0]	readData2; //Second output of regfile
	reg [31:0] registers [0:31]; //Regfile definition 32 registers with width one WORD
	

	
	// Parameters definition of Registers names
	parameter [4:0] zero=5'h0,at=5'h1,v0=5'h2,v1=5'h3,a0=5'h4,a1=5'h5,a2=5'h6,a3=5'h7,
			t0=5'h8,t1=5'h9,t2=5'ha,t3=5'hb,t4=5'hc,t5=5'hd,t6=5'he,t7=5'hf,
			s0=5'h10,s1=5'h11,s2=5'h12,s3=5'h13,s4=5'h14,s5=5'h15,s6=5'h16,s7=5'h17,
			t8=5'h18,t9=5'h19,k0=5'h1a,k1=5'h1b,gp=5'h1c,sp=5'h1d,fp=5'h1e,ra=5'h1f;
			
	// Writing on positive edge
	always @(posedge clk)
	begin
		if(writeEnb) 	registers[writeReg] <= writeData;
		else				registers[writeReg] <= registers[writeReg];
	end

	// Reading async	

	assign readData1 = registers[readReg1];
	assign readData2 = registers[readReg2];
	
endmodule
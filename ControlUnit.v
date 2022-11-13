module ControlUnit(opCode, regDst, jump, branch, memRead, memToReg, aluOp, memWrite, aluSrc, regWrite);
	
	input			[5:0] 	opCode;
	output reg	[1:0] 	aluOp;
	output reg				regDst, jump, branch, memRead, memToReg, memWrite, aluSrc, regWrite;
	
	
	always@(opCode)
	begin
		case(opCode)	
			0: begin // R-Format Inst	
				regDst	<= 1'b1;
				jump		<= 1'b0;
				branch	<= 1'b0;
				memRead	<= 1'b0;
				memToReg	<= 1'b0;
				aluOp		<= 2'b10;
				memWrite	<= 1'b0; 
				aluSrc	<= 1'b0;
				regWrite	<= 1'b1;
				end
				//I-Format supported instructions 						
//			4:  ControlLines<=12'b000_0001_00100; //BEQ
//			5:  ControlLines<=12'b000_0001_00100; //BNE
//			35: ControlLines<=12'b110_0000_11000; //LW
//			43: ControlLines<=12'b011_0000_00000; //SW
//			8:  ControlLines<=12'b110_0000_00000; //ADDI
//			12: ControlLines<=12'b110_0010_00000; //ANDI
//			13: ControlLines<=12'b110_0011_00000; //ORI
//			10: ControlLines<=12'b110_1000_00000; //SLTI
//			15: ControlLines<=12'b110_1001_00000; //LUI
//			14: ControlLines<=12'b110_1011_00000; //XORI
//
//				//J-Format supported instructions 	
//			2:  ControlLines<=12'b000_0000_00010; //J
//			3:  ControlLines<=12'b000_0000_00010; //JAL
			default: 
				begin
				regDst	<= 1'b0;
				jump		<= 1'b0;
				branch	<= 1'b0;
				memRead	<= 1'b0;
				memToReg	<= 1'b0;
				aluOp		<= 2'b00;
				memWrite	<= 1'b0; 
				aluSrc	<= 1'b0;
				regWrite	<= 1'b0;
				end
		endcase
	end

endmodule
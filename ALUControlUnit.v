module ALUControlUnit(funct, aluOp, aluControl);
	input 		[5:0] funct;
	input 		[1:0] aluOp;
	output reg	[3:0] aluControl;
	
	always @(funct,aluOp)
	begin
		// R-Format Inst
		if(aluOp==2'b10) begin
			case(funct)
				6'b100000:	aluControl <= 4'b0010;	//Add			
				6'b100010:	aluControl <= 4'b0110;	//Subtract
				6'b100100:	aluControl <= 4'b0000;	//AND
				6'b100101:	aluControl <= 4'b0001;	//OR
				default: 	aluControl <= 4'b0000;		
			endcase
		end
		// Branch equal
		else if(aluOp==2'b01) aluControl <= 4'b0110;		
		
		// LW and SW
		else aluControl <= 4'b0010;
		
	end

endmodule
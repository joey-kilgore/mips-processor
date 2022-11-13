module ALU(input1, input2, aluControl, shamt, aluResult, zero);
	input 		[31:0] 	input1, input2;
	input 		[3:0] 	aluControl;
	input			[4:0]		shamt;
	output reg	[31:0]	aluResult;
	output 					zero;
	
	assign zero = !(|aluResult);

	always @(*)
	begin
		case(aluControl)
			4'b0010: aluResult <= input1 + input2;	//Add
			4'b0110: aluResult <= input1 - input2; //Subtract
			4'b0000: aluResult <= input1 & input2;	//AND
			4'b0001: aluResult <= input1 | input2; //OR
			default: aluResult <= 32'b0;
		endcase
	end



endmodule
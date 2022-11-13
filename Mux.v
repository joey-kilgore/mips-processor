module Mux(D0, D1, S, Y);
	input 		[31:0]  	D0, D1;
	input 					S;
	output reg 	[31:0] 	Y;

	always @(*)
	begin
		if(S) 	Y <= D1;
		else 		Y <= D0;
	end

endmodule
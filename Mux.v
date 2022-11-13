module Mux(D0, D1, S, Y);
    parameter WIDTH = 32;

	input 		[WIDTH-1:0]  	D0, D1;
	input 					S;
	output reg 	[WIDTH-1:0] 	Y;

	always @(*)
	begin
		if(S) 	Y <= D1;
		else 		Y <= D0;
	end
endmodule

module Mux5(D0, D1, S, Y);
    parameter WIDTH = 5;

	input 		[WIDTH-1:0]  	D0, D1;
	input 					S;
	output reg 	[WIDTH-1:0] 	Y;

	always @(*)
	begin
		if(S) 	Y <= D1;
		else 		Y <= D0;
	end
endmodule

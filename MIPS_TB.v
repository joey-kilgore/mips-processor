module MIPS_TB;
	reg clk;
	
	MIPS testMips(clk);

	initial begin
        clk <= 1'b0;
        testMips.PC <= 32'h00000000;
        testMips.instMem[0] <= 32'h00411020;
        testMips.mipsRegFile.registers[1] = 32'h00000001;
        testMips.mipsRegFile.registers[2] = 32'h00000000;
		#100 $finish;
	end
	
	always #2 clk = ~clk;

    initial
    begin
    $shm_open("mywave.db");
    $shm_probe(MIPS_TB,"AS");
    $shm_save;
    end
endmodule

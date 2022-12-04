`timescale 1ns/100ps

module MIPS_TB;
	reg clk, rst;
	
	MIPS testMips(clk, rst);

	initial begin
        clk <= 1'b0;
		  rst <= 1'b0;
        testMips.PC <= 32'h00000000;
		  
		  #1 rst <= 1'b1;
		  #6 rst <= 1'b0;
		  
        testMips.instMem[0] <= 32'h02309020; //add $s2 $s1 $s0
        testMips.instMem[1] <= 32'h02309022; //sub $s2 $s1 $s0
        testMips.instMem[2] <= 32'h02309024; //and $s2 $s1 $s0
        testMips.instMem[3] <= 32'h02309025; //or  $s2 $s1 $s0
        testMips.instMem[4] <= 32'hAE720004; //sw $s2 0x4 $s3
        testMips.instMem[5] <= 32'h8E740004; //lw $s4 0x4 $s3
		  testMips.instMem[6] <= 32'hAE720104; //sw $s2 0x(100+4) $s3
		  testMips.instMem[7] <= 32'h8E740004; //lw $s4 0x4 $s3
        testMips.instMem[8] <= 32'h02309020; //add $s2 $s1 $s0
        testMips.instMem[9] <= 32'h02309022; //sub $s2 $s1 $s0
        testMips.instMem[10] <= 32'h02309024; //and $s2 $s1 $s0
        testMips.instMem[11] <= 32'h02309025; //or  $s2 $s1 $s0
		  
        testMips.mipsRegFile.registers[16] = 32'h000004D2; //s0 = 1234
        testMips.mipsRegFile.registers[17] = 32'h0000162E; //s1 = 5678
		  testMips.mipsRegFile.registers[19] = 32'h00000000; //s3 = 0

		  #100 
		  $stop;
		  $finish;
	end
	
	always #2 clk = ~clk;

//    initial
//    begin
//    $shm_open("mywave.db");
//    $shm_probe(MIPS_TB,"AS");
//    $shm_save;
//    end
endmodule

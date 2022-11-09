`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11/09/2022
// Design Name:   NextPClogic
// Module Name:   E:/350/Lab8/NextPClogic.v
// Project Name:  NextPClogic
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: NextPClogic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 16 // was 32
module NextPClogicTest_v;

   initial begin
      $dumpfile("NextPClogicTest.vcd");
      $dumpvars(0, NextPClogicTest_v);
   end

	task passTest;
	   input [63:0] expectOut, actualOut;
	   input [`STRLEN*8:0] testType;
	   inout [7:0] passed;

	       if (actualOut == expectOut) begin
                  $display("\n\n%s :: Passed\n\tCurrPC\t= %x\n\tSEImm64\t= %x\n\tBranch\t= %x\n\tALUZero\t= %x\n\tUnCondB\t= %x\n\tNextPC\t= %x", testType, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch, actualOut);
		  passed = passed + 1;
	       end
	       else $display("\n\n%s :: Failed\n\tCurrPC\t= %x\n\tSEImm64\t= %x\n\tBranch\t= %x\n\tALUZero\t= %x\n\tUnCondB\t= %x\n\tNextPC\t= %x\tShould be: %x", testType, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch, actualOut, expectOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

   // Inputs
   reg [63:0] 		    CurrentPC;
   reg [63:0] 		    SignExtImm64;
   reg 			    Branch, ALUZero, Uncondbranch;
   reg [7:0] 		    passed;
   
   // Outputs
   wire [63:0] 		    NextPC;

   // Instantiate the Unit Under Test (UUT)
   NextPClogic uut (
		    .NextPC(NextPC),
		    .CurrentPC(CurrentPC),
		    .SignExtImm64(SignExtImm64),
		    .Branch(Branch),
		    .ALUZero(ALUZero),
		    .Uncondbranch(Uncondbranch)
		    );

   initial begin
      // Initialize Inputs
      CurrentPC = 0;
      SignExtImm64 = 0;
      Branch = 0;
      ALUZero = 0;
      Uncondbranch = 0;
      passed = 0;
      
      // TEST VECTORS:
      $display ("8 Test Vectors:");
      // Test 1
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h30, 64'h4, 1'b1, 1'b1, 1'b0}; #40; 
      passTest(64'h40, {NextPC}, "1) CBZ+ True", passed);
      
      // Test 2
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h30, 64'h4, 1'b1, 1'b0, 1'b0}; #40;
      passTest(64'h34, {NextPC}, "2) CBZ+ False", passed);
      
      // Test 3
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h30, -64'h4, 1'b1, 1'b1, 1'b0}; #40;
      passTest(64'h20, {NextPC}, "3) CBZ- True", passed);
      
      // Test 4
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h30, -64'h4, 1'b1, 1'b0, 1'b0}; #40;
      passTest(64'h34, {NextPC}, "4) CBZ- False", passed);
      
      // Test 5
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h30, 64'h4, 1'b0, 1'b1, 1'b1}; #40;
      passTest(64'h40, {NextPC}, "5) B+ True", passed);
      
      // Test 6
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h30, 64'h4, 1'b0, 1'b0, 1'b1}; #40;
      passTest(64'h40, {NextPC}, "6) B+ False", passed);
      
      // Test 7
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h30, -64'h4, 1'b0, 1'b1, 1'b1}; #40;
      passTest(64'h20, {NextPC}, "7) B- True", passed);
      
      // Test 8
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h30, -64'h4, 1'b0, 1'b0, 1'b1}; #40;
      passTest(64'h20, {NextPC}, "8) B- False", passed);
      // Should be 8 tests total      
      
      allPassed(passed, 8);
   end   
endmodule


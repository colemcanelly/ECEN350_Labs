`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:47 03/05/2009
// Design Name:   ALU
// Module Name:   E:/350/Lab8/ALU/ALUTest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 12 // was 32
module ALUTest_v;

   initial begin
      $dumpfile("ALUTest.vcd");
      $dumpvars(0, ALUTest_v);
   end

	task passTest;
	   input gotZero;
	   input [63:0] actualOut;
	   input 	expZero;
	   input [63:0] expectedOut;
	   input [`STRLEN*8:0] testType;
	   inout [7:0] passed;

	       if (actualOut == expectedOut) begin
                   if (gotZero == expZero) begin
                       $display("%s :: Passed", testType); passed = passed + 1;
		   end
	           else $display("%s :: Failed:\n\tExpected zero = %x\n\t\tGot: %x", testType, expZero, gotZero);
	       end
	       else $display("%s :: Failed:\n\tExpected BusW = %x\n\t\tGot: %x", testType, expectedOut, actualOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [63:0] BusA;
	reg [63:0] BusB;
	reg [3:0] ALUCtrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;

                // Here is one example test vector, testing the ADD instruction:
		{ALUCtrl, BusA, BusB} = {4'h0, 64'h200, 64'h150}; #40; passTest(Zero, BusW, 1'b1, 64'h0, "AND1", passed);
		{ALUCtrl, BusA, BusB} = {4'h0, 64'h700, 64'h700}; #40; passTest(Zero, BusW, 1'b0, 64'h700, "AND2", passed);
		{ALUCtrl, BusA, BusB} = {4'h0, 64'h1234, 64'h4321}; #40; passTest(Zero, BusW, 1'b0, 64'h220, "AND3", passed);
		{ALUCtrl, BusA, BusB} = {4'h1, 64'h200, 64'h150}; #40; passTest(Zero, BusW, 1'b0, 64'h350, "OR1", passed);
		{ALUCtrl, BusA, BusB} = {4'h1, 64'h700, 64'h700}; #40; passTest(Zero, BusW, 1'b0, 64'h700, "OR2", passed);
		{ALUCtrl, BusA, BusB} = {4'h1, 64'h1234, 64'h4321}; #40; passTest(Zero, BusW, 1'b0, 64'h5335, "OR3", passed);
		{ALUCtrl, BusA, BusB} = {4'h2, 64'h200, 64'h150}; #40; passTest(Zero, BusW, 1'b0, 64'h350, "ADD1", passed);
		{ALUCtrl, BusA, BusB} = {4'h2, 64'h700, 64'h700}; #40; passTest(Zero, BusW, 1'b0, 64'he00, "ADD2", passed);
		{ALUCtrl, BusA, BusB} = {4'h2, 64'h1234, 64'h4321}; #40; passTest(Zero, BusW, 1'b0, 64'h5555, "ADD3", passed);
		{ALUCtrl, BusA, BusB} = {4'h6, 64'h200, 64'h150}; #40; passTest(Zero, BusW, 1'b0, 64'hb0, "SUB1", passed);
		{ALUCtrl, BusA, BusB} = {4'h6, 64'h700, 64'h700}; #40; passTest(Zero, BusW, 1'b1, 64'h0, "SUB2", passed);
		{ALUCtrl, BusA, BusB} = {4'h6, 64'h1234, 64'h4321}; #40; passTest(Zero, BusW, 1'b0, 64'hffffffffffffcf13, "SUB3", passed);
		{ALUCtrl, BusA, BusB} = {4'h7, 64'h200, 64'h150}; #40; passTest(Zero, BusW, 1'b0, 64'h150, "PassB1", passed);
		{ALUCtrl, BusA, BusB} = {4'h7, 64'h700, 64'h700}; #40; passTest(Zero, BusW, 1'b0, 64'h700, "PassB2", passed);
		{ALUCtrl, BusA, BusB} = {4'h7, 64'h1234, 64'h4321}; #40; passTest(Zero, BusW, 1'b0, 64'h4321, "PassB3", passed);
		//Reformate and add your test vectors from the prelab here following the example of the testvector above.	


		allPassed(passed, 15);
	end
      
endmodule


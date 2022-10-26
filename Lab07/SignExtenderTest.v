`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:47 03/05/2009
// Design Name:   ALU
// Module Name:   E:/350/Lab7/SignExtenderTest.v
// Project Name:  SignExtender
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SignExtender
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 32
module SignExtenderTest_v;

   initial begin
      $dumpfile("SignExtenderTest.vcd");
      $dumpvars(0, SignExtenderTest_v);
   end
	task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
        reg [25:0]  Input;
        reg [1:0]  Ctrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusImm;

	// Instantiate the Unit Under Test (UUT)
	SignExtender uut (
		.BusImm(BusImm),
		.Input(Input),
		.Ctrl(Ctrl)
	);

	initial begin
		// Initialize Inputs
		Input = 0;
		Ctrl = 0;
		passed = 0;

                // Here is one example test vector, testing the ADD instruction:
		{Input, Ctrl} = {26'h24, 2'h0}; #40; passTest({BusImm}, 64'h24, "SE I-0", passed);
	        {Input, Ctrl} = {26'b11111111111111111111011100, 2'h0}; #40; passTest({BusImm}, 64'hffffffffffffffdc, "SE I-1", passed);
	        {Input, Ctrl} = {26'h24, 2'h1}; #40; passTest({BusImm}, 64'h24, "SE D-0", passed);
	        {Input, Ctrl} = {26'b11111111111111111111011100, 2'h1}; #40; passTest({BusImm}, 64'hffffffffffffffdc, "SE D-1", passed);
	        {Input, Ctrl} = {26'h24, 2'h2}; #40; passTest({BusImm}, 64'h24, "SE B-0", passed);
	        {Input, Ctrl} = {26'b11111111111111111111011100, 2'h2}; #40; passTest({BusImm}, 64'hffffffffffffffdc, "SE B-1", passed);
	        {Input, Ctrl} = {26'h24, 2'h3}; #40; passTest({BusImm}, 64'h24, "SE CB-0", passed);
	        {Input, Ctrl} = {26'b11111111111111111111011100, 2'h3}; #40; passTest({BusImm}, 64'hffffffffffffffdc, "SE CB-1", passed);
	        
		//Reformate and add your test vectors from the prelab here following the example of the testvector above.	


		allPassed(passed, 8);
	end
      
endmodule


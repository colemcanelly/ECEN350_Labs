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
//$display ("%s passed", testType)
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
		input [63:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("\tpassed\t%s", testType); passed = passed + 1; end
		else $display ("\tfailed\t%s\n\t: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
        reg [25:0]  Input;
        reg [2:0]  Ctrl;
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
	        $display ("8 Test Vectors:");
			{Input, Ctrl} = {26'h444, 3'h0}; #40; passTest({BusImm}, 64'h1, "I  :: Positive", passed);
	        {Input, Ctrl} = {26'hfff73ff, 3'h0}; #40; passTest({BusImm}, 64'hffffffffffffffdc, "I  :: Negative", passed);
	        {Input, Ctrl} = {26'h1234, 3'h1}; #40; passTest({BusImm}, 64'h1, "D  :: Positive", passed);
	        {Input, Ctrl} = {26'hffdcfff, 3'h1}; #40; passTest({BusImm}, 64'hffffffffffffffdc, "D  :: Negative", passed);
	        {Input, Ctrl} = {26'h24, 3'h2}; #40; passTest({BusImm}, 64'h24, "B  :: Positive", passed);
	        {Input, Ctrl} = {26'hfffffdc, 3'h2}; #40; passTest({BusImm}, 64'hffffffffffffffdc, "B  :: Negative", passed);
	        {Input, Ctrl} = {26'h20, 3'h3}; #40; passTest({BusImm}, 64'h1, "CB :: Positive", passed);
	        {Input, Ctrl} = {26'hffffb9f, 3'h3}; #40; passTest({BusImm}, 64'hffffffffffffffdc, "CB :: Negative", passed);
			// Tests for new operation in Lab09: MOVZ
			{Input, Ctrl} = {26'h399c62f, 3'h4}; #40; passTest({BusImm}, 64'hce31, "IM :: Test #1 [ce31 << 0]", passed);
			{Input, Ctrl} = {26'h3b9c62f, 3'h4}; #40; passTest({BusImm}, 64'hce310000, "IM :: Test #2 [ce31 << 16]", passed);
			{Input, Ctrl} = {26'h3d9c62f, 3'h4}; #40; passTest({BusImm}, 64'hce3100000000, "IM :: Test #3 [ce31 << 32]", passed);
			{Input, Ctrl} = {26'h3f9c62f, 3'h4}; #40; passTest({BusImm}, 64'hce31000000000000, "IM :: Test #4 [ce31 << 48]", passed);
			{Input, Ctrl} = {26'h101418c, 3'h4}; #40; passTest({BusImm}, 64'ha0c, "IM :: Test #5 [a0c << 0]", passed);
			{Input, Ctrl} = {26'h121418c, 3'h4}; #40; passTest({BusImm}, 64'ha0c0000, "IM :: Test #6 [a0c << 16]", passed);
			{Input, Ctrl} = {26'h141418c, 3'h4}; #40; passTest({BusImm}, 64'ha0c00000000, "IM :: Test #7 [a0c << 32]", passed);
			{Input, Ctrl} = {26'h161418c, 3'h4}; #40; passTest({BusImm}, 64'ha0c000000000000, "IM :: Test #8 [a0c << 48]", passed);
			{Input, Ctrl} = {26'h305c7b9, 3'h4}; #40; passTest({BusImm}, 64'h2e3d, "IM :: Test #9 [2e3d << 0]", passed);
			{Input, Ctrl} = {26'h325c7b9, 3'h4}; #40; passTest({BusImm}, 64'h2e3d0000, "IM :: Test #10 [2e3d << 16]", passed);
			{Input, Ctrl} = {26'h345c7b9, 3'h4}; #40; passTest({BusImm}, 64'h2e3d00000000, "IM :: Test #11 [2e3d << 32]", passed);
			{Input, Ctrl} = {26'h365c7b9, 3'h4}; #40; passTest({BusImm}, 64'h2e3d000000000000, "IM :: Test #12 [2e3d << 48]", passed);
	        
		//Reformate and add your test vectors from the prelab here following the example of the testvector above.	


		allPassed(passed, 20);
	end  

      
endmodule


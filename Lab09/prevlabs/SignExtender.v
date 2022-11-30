`define I    2'b00
`define D    2'b01
`define B    2'b10
`define CB   2'b11

module SignExtender(BusImm, Input, Ctrl); 
   output [63:0] BusImm; 
   input [25:0]  Input; 
   input [1:0]	 Ctrl; 
   
   wire 	 extBit;

   // Passed Tests
   assign extBit =
		  (Ctrl == `I) ? Input[21] : // I
		  (Ctrl == `D) ? Input[20] : // D
		  (Ctrl == `B) ? Input[25] : // B
                      Input[23];             // CB

   
   assign BusImm =
		  (Ctrl == `I) ? {{52{extBit}}, Input[21:10]} : // I
		  (Ctrl == `D) ? {{55{extBit}}, Input[20:12]} : // D
		  (Ctrl == `B) ? {{38{extBit}}, Input} :        // B
		      {{45{extBit}}, Input[23:5]};              // CB
   
endmodule

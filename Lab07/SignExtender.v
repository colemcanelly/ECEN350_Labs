module SignExtender(BusImm, Input, Ctrl); 
   output [63:0] BusImm; 
   input [25:0]  Input; 
   input [1:0]	 Ctrl; 
   
   wire 	 extBit;
   
   assign extBit =
		  (Ctrl == 2'b00) ? Input[21] : // I
		  (Ctrl == 2'b01) ? Input[20] : // D
		  (Ctrl == 2'b10) ? Input[25] : Input[23]; // B, else CB
 
   assign BusImm =
		  (Ctrl == 2'b00) ? {{52{extBit}}, Input[21:10]} : // I
		  (Ctrl == 2'b01) ? {{55{extBit}}, Input[20:12]} : // D
		  (Ctrl == 2'b10) ? {{38{extBit}}, Input} : {{45{extBit}}, Input[23:5]}; // B, else CB
   
endmodule

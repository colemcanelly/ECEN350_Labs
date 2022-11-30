`define I   3'b000
`define D   3'b001
`define B   3'b010
`define CB  3'b011
`define IM  3'b100

module SignExtender(BusImm, Input, Ctrl); 
   output [63:0] BusImm; 
   input [25:0]  Input; 
   input [2:0]	 Ctrl; 
   
   wire 	 extBit;

   wire [6:0] 	 shift;
   wire [63:0]   movz;

   assign shift = Input[22:21] << 4;     // Get shift * 16
   assign movz  = Input[20:5] << shift;  // movz_imm << shift

   assign extBit =
		  (Ctrl ==  `I) ? Input[21] : // I
		  (Ctrl ==  `D) ? Input[20] : // D
		  (Ctrl ==  `B) ? Input[25] : // B
          (Ctrl == `CB) ? Input[23] : // CB
          1'b0;                       // IM and default

   
   assign BusImm =
		  (Ctrl ==  `I) ? {{52{extBit}}, Input[21:10]} : // I
		  (Ctrl ==  `D) ? {{55{extBit}}, Input[20:12]} : // D
		  (Ctrl ==  `B) ? {{38{extBit}}, Input[25: 0]} : // B
          (Ctrl == `CB) ? {{45{extBit}}, Input[23: 5]} : // CB
          (Ctrl == `IM) ? {movz} : {64'b0};  // Default BusImm = 0
endmodule

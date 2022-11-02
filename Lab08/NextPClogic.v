////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
// VARS:                                                                      //
//     - SignExtImm64 = Output of sign extender                               //
//     - CurrentPC    = Current program counter                               //
//     - Branch       = `true` if instruction type B                          //
//     - Uncondbranch = `true` if instruction type CB                         //
//     - ALUZero      = ALU "zero" output                                     //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
   input [63:0] CurrentPC, SignExtImm64; 
   input 	Branch, ALUZero, Uncondbranch; 
   output [63:0] NextPC; 

   /* write your code here */
   wire 	 sel = ((ALUZero & Branch) | Uncondbranch);

   // Might have to put `CurrentPC` inside ternary operator result
   assign NextPC = CurrentPC + (sel ? (SignExtImm64<<2) : (3'b100));

endmodule

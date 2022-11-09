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

   // Boolean algebra to determine the `select` bit for the mux
   wire 	 sel = ((ALUZero & Branch) | Uncondbranch);

   // If the select is true (take the branch) add the SE<<2 to the current PC
   //  if select is false, increment to next instruction (+4)
   assign NextPC = CurrentPC + (sel ? (SignExtImm64<<2) : (3'b100));

endmodule

module Mux21 (out, in, sel);

   input [1:0] in;
   input       sel;
   output      out;

   wire        w1, w2, w3;
   
   not n1(w1, sel);
   and a1(w2, in[0], w1);
   and a2(w3, in[1], sel);
   or o1(out, w2, w3);

endmodule

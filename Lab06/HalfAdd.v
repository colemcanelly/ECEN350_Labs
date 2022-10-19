module HalfAdd ( Cout , Sum , A, B ) ;
   input A, B ;
   output Cout , Sum ;
   wire   t1, t2, t3;
   nand nand1(t1, A, B);
   nand nand2(t2, A, t1);
   nand nand3(t3, t1, B);
   nand nand4(Sum, t2, t3);
   nand nand5(Cout, t1, t1);
endmodule

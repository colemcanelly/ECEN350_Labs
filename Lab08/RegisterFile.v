module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
   output [63:0] BusA;   
   output [63:0] BusB;
   input [63:0]  BusW;
   input [4:0] 	 RA, RB, RW;
   input 	 RegWr;
   input 	 Clk;
   reg [63:0] 	 registers [31:0]; // 32 registers, each 64 bits
     
   assign #2 BusA = ((RA == 31) ? 64'h0 : registers[RA]);
   assign #2 BusB = ((RB == 31) ? 64'h0 : registers[RB]);
     
   always @ (negedge Clk) begin
      if(RegWr)
        registers[RW] <= #3 BusW;
   end
endmodule

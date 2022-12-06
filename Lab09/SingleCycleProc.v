module singlecycle(
		   input 	     resetl,
		   input [63:0]      startpc,
		   output reg [63:0] currentpc,
		   output [63:0]     MemtoRegOut,  // this should be
						   // attached to the
						   // output of the
						   // MemtoReg Mux
		   input 	     CLK
		   );

   // Next PC connections
   wire [63:0] 			     nextpc;       // The next PC, to be updated on clock cycle

   // Instruction Memory connections
   wire [31:0] 			     instruction;  // The current instruction

   // Parts of instruction
   wire [4:0] 			     rd;            // The destination register
   wire [4:0] 			     rm;            // Operand 1
   wire [4:0] 			     rn;            // Operand 2
   wire [10:0] 			     opcode;

   // Control wires
   wire 			     reg2loc;
   wire 			     alusrc;
   wire 			     mem2reg;
   wire 			     regwrite;
   wire 			     memread;
   wire 			     memwrite;
   wire 			     branch;
   wire 			     uncond_branch;
   wire [3:0] 			     aluctrl;
   wire [2:0] 			     signop;

   // Register file connections
   wire [63:0] 			     regoutA;     // Output A
   wire [63:0] 			     regoutB;     // Output B

   // ALU connections
   wire [63:0] 			     alusrc_out; // Done
   wire [63:0] 			     aluout;     // Done
   wire 			     zero;       // Done

   // Sign Extender connections
   wire [63:0] 			     extimm;
   wire [25:0] 			     seInput;

   // Data Memory connections
   wire [63:0] 			     readData;
   

   // PC update logic
   always @(negedge CLK)
     begin
        if (resetl)
          currentpc <= #3 nextpc;
        else
          currentpc <= #3 startpc;
     end

   // Parts of instruction
   assign rd = instruction[4:0];
   assign rm = instruction[9:5];
   assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
   assign opcode = instruction[31:21];

   // Internal Connections
   assign alusrc_out = alusrc ? extimm : regoutB;
   assign MemtoRegOut = mem2reg ? readData : aluout;
   assign seInput = instruction[25:0];
   
   

   InstructionMemory imem(
			  .Data(instruction),
			  .Address(currentpc)
			  );

   control control(
		   .reg2loc(reg2loc),
		   .alusrc(alusrc),
		   .mem2reg(mem2reg),
		   .regwrite(regwrite),
		   .memread(memread),
		   .memwrite(memwrite),
		   .branch(branch),
		   .uncond_branch(uncond_branch),
		   .aluop(aluctrl),
		   .signop(signop),
		   .opcode(opcode)
		   );
   
   /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */

   // Lab07
   ALU alu(
	   .BusW(aluout),
	   .BusA(regoutA),
	   .BusB(alusrc_out),
	   .ALUCtrl(aluctrl),
	   .Zero(zero)
	   );   // Done
   
   SignExtender se(
		   .BusImm(extimm),
		   .Input(seInput),
		   .Ctrl(signop)
		   ); // Done
   
   // Lab08
   NextPClogic pclogic(
		       .CurrentPC(currentpc),
		       .SignExtImm64(extimm),
		       .Branch(branch),
		       .ALUZero(zero),
		       .Uncondbranch(uncond_branch),
		       .NextPC(nextpc)
		       );  // Done
   
   RegisterFile rf(
        .RegWr(regwrite),
        .RA(rm),
        .RB(rn),
        .RW(rd),
        .BusW(MemtoRegOut),
        .BusA(regoutA),
        .BusB(regoutB),
        .Clk(CLK)
        );
   

   // Lab09
   DataMemory dmem(
          .Address(aluout),
          .WriteData(regoutB),
          .ReadData(readData),
          .MemoryWrite(memwrite),
          .MemoryRead(memread),
          .Clock(CLK)
          );


endmodule


`define OPCODE_ANDREG 11'b10001010000
`define OPCODE_ORRREG 11'b10101010000
`define OPCODE_ADDREG 11'b10001011000
`define OPCODE_SUBREG 11'b11001011000

`define OPCODE_ADDIMM 11'b1001000100Z   // Figure out later lol
`define OPCODE_SUBIMM 11'b1101000100Z

`define OPCODE_MOVZ   11'b110100101ZZ

`define OPCODE_B      11'b000101ZZZZZ
`define OPCODE_CBZ    11'b10110100ZZZ

`define OPCODE_LDUR   11'b11111000010
`define OPCODE_STUR   11'b11111000000

// Use `z` for "don't care" values because we are using `casez`

module control(
	       output reg 	reg2loc,
	       output reg 	alusrc,
	       output reg 	mem2reg,
	       output reg 	regwrite,
	       output reg 	memread,
	       output reg 	memwrite,
	       output reg 	branch,
	       output reg 	uncond_branch,
	       output reg [3:0] aluop,
	       output reg [1:0] signop,
	       input [10:0] 	opcode
	       );

   always @(*)
     begin
	casez (opcode)
	  /* Add cases here for each instruction your processor supports */
	  `OPCODE_ANDREG:
	    begin
               reg2loc       = 1'b0;
	       uncond_branch = 1'b0;
	       branch        = 1'b0;
	       memread       = 1'b0;
	       mem2reg       = 1'b0;
	       memwrite      = 1'b0;
               alusrc        = 1'b0;
	       regwrite      = 1'b1;
	       signop        = 2'bzz;
               aluop         = 4'b0000;
            end // case: `OPCODE_ANDREG
	  `OPCODE_ORRREG:
	    begin
               reg2loc       = 1'b0;
	       uncond_branch = 1'b0;
	       branch        = 1'b0;
	       memread       = 1'b0;
	       mem2reg       = 1'b0;
	       memwrite      = 1'b0;
               alusrc        = 1'b0;
	       regwrite      = 1'b1;
	       signop        = 2'bzz;
               aluop         = 4'b0001;
            end
	  `OPCODE_ADDREG:
	    begin
               reg2loc       = 1'b0;
	       uncond_branch = 1'b0;
	       branch        = 1'b0;
	       memread       = 1'b0;
	       mem2reg       = 1'b0;
	       memwrite      = 1'b0;
               alusrc        = 1'b0;
	       regwrite      = 1'b1;
	       signop        = 2'bzz;
               aluop         = 4'b0010;
            end
	  `OPCODE_SUBREG:
	    begin
               reg2loc       = 1'b0;
	       uncond_branch = 1'b0;
	       branch        = 1'b0;
	       memread       = 1'b0;
	       mem2reg       = 1'b0;
	       memwrite      = 1'b0;
               alusrc        = 1'b0;
	       regwrite      = 1'b1;
	       signop        = 2'bzz;
               aluop         = 4'b0110;
            end
	  `OPCODE_ADDIMM:
	    begin
               reg2loc       = 1'b0;
	       uncond_branch = 1'b0;
	       branch        = 1'b0;
	       memread       = 1'b0;
	       mem2reg       = 1'b0;
	       memwrite      = 1'b0;
               alusrc        = 1'b1;
	       regwrite      = 1'b1;
	       signop        = 2'b00;
               aluop         = 4'b0010;
            end
	  `OPCODE_SUBIMM:
	    begin
               reg2loc       = 1'b0;
	       uncond_branch = 1'b0;
	       branch        = 1'b0;
	       memread       = 1'b0;
	       mem2reg       = 1'b0;
	       memwrite      = 1'b0;
               alusrc        = 1'b1;
	       regwrite      = 1'b1;
	       signop        = 2'b00;
               aluop         = 4'b0110;
            end
	  `OPCODE_MOVZ: ; // Implement in Question 4 & 5
	  `OPCODE_B:
	    begin
               reg2loc       = 1'bz;
	       uncond_branch = 1'b1;
	       branch        = 1'bz;
	       memread       = 1'b0;
	       mem2reg       = 1'bz;
	       memwrite      = 1'b0;
               alusrc        = 1'bz;
	       regwrite      = 1'b0;
	       signop        = 2'b10;
               aluop         = 4'bzzzz;
            end
	  `OPCODE_CBZ:
	    begin
               reg2loc       = 1'b1;
	       uncond_branch = 1'b0;
	       branch        = 1'b1;
	       memread       = 1'b0;
	       mem2reg       = 1'bz;
	       memwrite      = 1'b0;
               alusrc        = 1'b0;
	       regwrite      = 1'b0;
	       signop        = 2'b11;
               aluop         = 4'b0111;
            end
	  `OPCODE_LDUR:
	    begin
               reg2loc       = 1'bz;
	       uncond_branch = 1'b0;
	       branch        = 1'b0;
	       memread       = 1'b1;
	       mem2reg       = 1'b1;
	       memwrite      = 1'b0;
               alusrc        = 1'b1;
	       regwrite      = 1'b1;
	       signop        = 2'b01;
               aluop         = 4'b0010;
            end
	  `OPCODE_STUR:
	    begin
               reg2loc       = 1'b1;
	       uncond_branch = 1'b0;
	       branch        = 1'b0;
	       memread       = 1'b0;
	       mem2reg       = 1'bz;
	       memwrite      = 1'b1;
               alusrc        = 1'b1;
	       regwrite      = 1'b0;
	       signop        = 2'b01;
               aluop         = 4'b0010;
            end
          default:
            begin
               reg2loc       = 1'bz;
               alusrc        = 1'bz;
               mem2reg       = 1'bz;
               regwrite      = 1'b0;
               memread       = 1'b0;
               memwrite      = 1'b0;
               branch        = 1'b0;
               uncond_branch = 1'b0;
               aluop         = 4'bzzzz;
               signop        = 2'bzz;
            end
	endcase
     end

endmodule


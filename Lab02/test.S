
.section .text
.globl test

test:
	ADRP X0, msg1 		// Load address of msg1 0 into X0 ( part 1 )
	ADD X0,X0, :lo12:msg1 	// X0 = &msg1
	ADR X1, msg2		// X1 = &msg2
	ADRP X6, num1		// Part 1 load num1 into X6
	ADD X6,X6, :lo12:num1	// X6 = &num1
	LDURB w2, [X6,0]	// W2 = *X6 		thus:  W2 == 0xXXXXXX2D
	LDURSH X3,[X6,1]	// X3 = *(X6 + 1byte)	thus:  X3 == 0xfffffffffffff654
	LDURSW X4,[X6,3]	// X4 = *(X6 + 3byte)	thus:  X4 == 0xffffffffcafebabe
	LDUR X5,[X6,7]		// X5 = *(X6 + 7byte)	thus:  X5 == 0x00000000feedface
	BR X30
 .section       .data
        msg1:	.asciz "A 17 byte message"
        msg2:	.asciz "Another message of 27 bytes"
        num1:	.byte 45
        num2:	.hword 0xf654
        num3:	.word 0xcafebabe
        num4:	.quad 0xfeedface


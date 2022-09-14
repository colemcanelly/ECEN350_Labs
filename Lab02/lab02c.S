.section .text
.globl lab02c

lab02c:
	ADRP	X3, hextable
	ADD 	X3, X3, :lo12:hextable	// X3 = &hextable
	ADRP 	X5, result
	ADD 	X5, X5, :lo12:result	// X5 = &result
	LSR	X1, X0, 4		// get upper 4 bits (argument passed in?)
	ADD 	X2, X1, X3		// Get address in hextable
	LDURB	W4, [X2, 0]		// Get character
	STURB 	W4, [X5, 0]		// First digit of the result
	AND 	X1, X0, 0xf		// Get lower 4 bits
	ADD 	X2, X3, X1		// Get address in hextable
	LDURB	W4, [X2, 0]		// Get character
	STURB	W4, [X5, 1]		// First digit of the result
	ORR	X0, X5, XZR		// X0 = X5 (X0 is return location)
	BR 	X30

.section .data
hextable:
	.asciz "0123456789abcdef"

msg1:
	.asciz "Your number in Hex is: "

result:
	.byte 2

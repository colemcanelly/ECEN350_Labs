
.section .text
.globl test2

test2:
	SUB	X1, X0, X1

	SUB	SP, SP, 0x10
	STUR	LR, [SP, 0x0]

	ADRP	X0, output
	ADD	X0, X0, :lo12:output
	BL	printf

	LDUR	LR, [SP, 0x0]
	ADD	SP, SP, 0x10
	BR	LR


.section .data

output:
	.asciz	"Result of test2(6,5) = %lld\n"

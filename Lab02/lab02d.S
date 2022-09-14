.section .text

.globl lab02d

lab02d:
	ADD 	X1, X0, #1000
	ADRP	X0, myvalue
	ADD	X0, X0, :LO12:myvalue
	STUR	X1, [X0, 0x0]

.section .data
myvalue:
	.quad 0x0

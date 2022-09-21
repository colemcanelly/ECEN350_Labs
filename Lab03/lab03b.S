.section .text
.globl lab03b

lab03b:
	ADRP 	X11, uin
	ADD 	X11, X11, :lo12:uin	// X11 = &uin
	LDUR	X0, [X11, 0]		// X0 = *X11
	ORR 	X9, XZR, XZR		// i = 0

loop:
	SUBS	XZR, X9, 10		// while {
	B.GE	exit			// (i < 10)
	SUB	X0, X0, 1		// --uin
	ADD	X9, X9, 1		// ++i
	B	loop			// }

exit:
	STUR	X0, [X11, 0]
	BR	LR




.section .data
uin:	.quad 28

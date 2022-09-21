.section .text
.globl lab03c

lab03c:
	MOV	X1, 6			// X1 = 6
	ADRP 	X0, my_array
	ADD 	X0, X0, :lo12:my_array	// X11 = my_array[0]
	ORR 	X2, XZR, XZR		// i = 0

loop:
	SUBS	XZR, X2, 10		// for {
	B.GE	exit			// (i < 10)
	LSL	X9, X2, 3		// i *= 8
	ADD	X9, X9, X0		// temp = i + my_array
	STUR	X1, [X9, 0]		// my_array[temp] = j
	ADD	X1, X1, 1		// ++j
	ADD	X2, X2, 1		// ++i
	B	loop			// }

exit:
	BR	LR			// return

.section .data
my_array:	.space 80

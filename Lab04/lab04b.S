.section .text
.globl fact
.extern my_mul

fact:
	CBNZ	X0, else	// if (n == 0) {
	ADD	X0, X0, 0x1	// x0 = 1
	BR	LR		// return

else:
	SUB	SP, SP, 0x10	// Decrement stack
	STUR	LR, [SP, 0x0]	// push: SP[0] = LR
	STUR	X0, [SP, 0x8]	// push: SP[1] = `n`
	SUB	X0, X0, 1	// n = n - 1
	BL	fact		// call fact(n - 1)
	LDUR    X1, [SP, 0x8]   // pop: `n` = SP[1]
	BL      my_mul          // Call my_mul(m, n); result in x0
	LDUR	LR, [SP, 0x0]	// pop: LR = SP[0]
	ADD	SP, SP, 0x10	// restore stack pointer
	BR	LR		// Return

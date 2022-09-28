        .globl my_mul

my_mul:
        //Multiply X0 and X1
        //   Does not handle negative X1!
        //   Note : This is an in efficient way to multipy!
        SUB 	SP, SP, 16	//make room for X19 on the stack
        STUR 	X19, [SP, 0]    //push X19
        ADD 	X19, X1, XZR    //set X19 equal to X1
        ADD 	X9 , XZR , XZR  //set X9 to 0
mult_loop:
        CBZ 	X19,  mult_eol	// while (x19 != 0) {
        ADD 	X9, X9, X0	// x9 += x0
        SUB 	X19, X19, 1	// x19--
        B 	mult_loop	// }
mult_eol:
        LDUR 	X19, [SP, 0]	// pop x19
	ADD	SP, SP, 16	// reset stack
        ADD 	X0, X9, XZR	// Move X9 to X0 to return
        BR 	X30		// Return


// Use the MOVZ instruction, and any other instructions needed, to construct the following constant 0x123456789abcdef0 in register X9.
// Store this immediate value to memory at memory address 0x28
// Load this value back to register X10 

// MOVZ <Rd>, #<Imm>, lsl <sh>

MOVZ    X9, 0x1234, lsl #48     // get first quarter of number
MOVZ    X10, 0x5678, lsl #32    // get second quarter of number
MOVZ    X11, 0x9abc, lsl #16    // get third quarter of number
MOVZ    X12, 0xdef0, lsl #0     // get last quarter of number

ADD     X13, X11, X12
ADD     X14, X9, X10
ADD     X9, X13, X14

STUR    X9, [XZR, 0x28]
LDUR    X10, [XZR, 0x28]
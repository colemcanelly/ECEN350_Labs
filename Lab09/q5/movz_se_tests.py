#!/usr/bin/python3
from random import *

"""
This is a script to generate verilog HDL test cases for the Lab07 sign extender
to ensure that the MOVZ command for Lab09 is accommodated and implemented correctly

The IM instruction type looks like this:
	 ________________________________________________________
	|31        23|22  21|20     <-  16 bits  ->      5|4    0|
	|   opcode   | sham |          immediate          |  Rd  |
	|____________|______|_____________________________|______|

The sign extender module takes the lower 26 bits, so it will take bits [25:0] as an input:
	- 3 bits from the opcode
	- 2 bits of the shamt
	- 16 bit signed immediate
	- 5 bits for the register destination
"""

def output_test(testnum, __op, __sh, __imm, __rd):
	# Build instruction (test input)
	instruction = __op << 2			# Make room for shamt
	instruction |= __sh				# Add Shift amount to instruction
	instruction <<= 16				# Make room for immediate
	instruction |= __imm			# Add Immediate to the instruction
	instruction <<= 5				# Make room for register
	instruction |= __rd				# Add Rd into instruction
	# Instruction is complete!
	output = __imm << (__sh * 16)	# Build test ouput

	# Build string args for the test
	s_instruction = hex(instruction)[2:]
	s_output = hex(output)[2:]
	s_name = "IM :: Test #%d [%x << %d]" % (testnum, __imm, __sh * 16)
	assert(len(s_name) <= 32)

	# Output test case
	print("{Input, Ctrl} = {26'h%s, 3'h4}; #40; passTest({BusImm}, 64'h%s, \"%s\", passed);" % (s_instruction, s_output, s_name))


print("Generating MOVZ Tests:\n")

currtest = 1
numgroups = 3

opcode = 0b111				# Initial value for opcode
num = 0b1100111000110001	# Initial value for num
register = 0b01111			# Initial reg value

for group in range(0, 3):
	# Test the given values for each shift amount
	for shift in range(0,4):
		output_test(currtest, opcode, shift, num, register)
		currtest += 1
	
	# Generate new random values for the next test
	opcode = int(random() * 0b111)
	num = int(random() * 0b1111111111111111)
	register = int(random() * 0b11111)
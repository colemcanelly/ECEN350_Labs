#!/usr/bin/python3

import argparse, re

#########################################################################################
##      GLOBAL CONSTANTS

# R type        CMD <Rd>, <Rn>, <Rm>
R = {
    "AND": '10001010000',
    "ORR": '10101010000',
    "ADD": '10001011000',
    "SUB": '11001011000'
}

# I type        CMD <Rd>, <Rn>, #<Imm>
I = {
    "ADDI": '1001000100',
    "SUBI": '1101000100'
}

# D type        CMD <Rd>, [<Rn>, #<imm>]
D = {
    "LDUR":  '11111000010',
    "STUR": '11111000000'
}

# B type        B <label>
B = {
    "B": '000101'
}

# CB type       CBZ <Rd>, <label>
CB = {
    "CBZ": '10110100'
}

# IM type       MOVZ <Rd>, #<Imm>, lsl #<sh>
IM = {
    "MOVZ": '110100101'
}

VERBOSE_MODE = False
VERILOG_FORMAT = False

#########################################################################################
##      HANDLE IMMEDIATE VALUES
def imm_to_dec(immediate: str):
    return int(immediate, base=0) # base=0 for type guessing; if "0x" then hex, "0b" then binary

def dec_to_bin(decimal_number: int, size: int):
    if (decimal_number >= 0):
        return bin(decimal_number)[2:].rjust(size, '0')
    else:
        decimal_number *= -1
        overflow = int(('1' * size), base=2)
        negnum = (decimal_number ^ overflow) + 1
        return bin(negnum)[2:]


#########################################################################################
##      INSTRUCTIONS
def instruction(asm: list):
    global VERBOSE_MODE
    instr = "".join(asm)
    assert len(instr) == 32, f"32bit instruction expected, got: {len(instr)}"
    if (VERBOSE_MODE): print("|" + "|".join(asm) + "|")
    return instr

# R type        CMD <Rd>, <Rn>, <Rm>
def handle_r(opcode: str, args: list):
    rd = bin(int(args[0][1:]))[2:].rjust(5, '0')
    rn = bin(int(args[1][1:]))[2:].rjust(5, '0')
    rm = bin(int(args[2][1:]))[2:].rjust(5, '0')
    shamt = '000000'
    return instruction([opcode, rm, shamt, rn, rd])

# I type        CMD <Rd>, <Rn>, #<Imm>
def handle_i(opcode: str, args: list):
    rd = bin(int(args[0][1:]))[2:].rjust(5, '0')
    rn = bin(int(args[1][1:]))[2:].rjust(5, '0')
    imm = dec_to_bin(imm_to_dec(args[2]), 12)       # 12bit immediate
    return instruction([opcode, imm, rn, rd])

# D type        CMD <Rt>, [<Rn>, #<imm>]
def handle_d(opcode: str, args: list):
    rt = bin(int(args[0][1:]))[2:].rjust(5, '0')
    rn = bin(int(args[1][1:]))[2:].rjust(5, '0')
    op = "00"
    offset = dec_to_bin(imm_to_dec(args[2]), 9)     # 9 bit immediate (-256, 255)
    return instruction([opcode, offset, op, rn, rt])

# B type        B <label>
def handle_b(opcode: str, args: list, labels: dict, ln: int, line: str):
    assert args[0] in labels.keys(), f"Unknown label: \"\033[1;31m{args[0]}\033[0m\" in line {ln}"
    addr = dec_to_bin(labels[args[0]] - ln, 26)     # 26bit address
    return instruction([opcode, addr])

# CB type       CBZ <Rt>, <label>
def handle_cb(opcode: str, args: list, labels: dict, ln: int, line: str):
    rt = bin(int(args[0][1:]))[2:].rjust(5, '0')
    assert args[1] in labels.keys(), f"Unknown label: \"\033[1;31m{args[1]}\033[0m\" in line {ln}"
    addr = dec_to_bin(labels[args[1]] - ln, 19)     # 19bit address
    return instruction([opcode, addr, rt])

# IM type       MOVZ <Rd>, #<Imm>, lsl #<sh>
def handle_im(opcode: str, args: list, ln: int, line: str):
    rd = bin(int(args[0][1:]))[2:].rjust(5, '0')
    imm = dec_to_bin(imm_to_dec(args[1]), 16)       # 16bit immediate
    dec_sh = imm_to_dec(args[3])
    assert (dec_sh % 16) == 0, f"Multiple of 16 shift amount expected, got: {dec_sh}"
    sh = bin(int(dec_sh / 16))[2:].rjust(2, '0')
    return instruction([opcode, sh, imm, rd])


#########################################################################################

def assemble_line(line: str, l_n: int, labels: dict):
    cmd = line[:line.find(" ")]
    argstring = line[line.find(" "):]
    argstring = argstring.replace(' ', '')
    args = re.split(',\[|,#|#|,|\]', argstring)
    
    if (cmd in R.keys()):
        return handle_r(R[cmd], args)
    elif (cmd in I.keys()):
        return handle_i(I[cmd], args)
    elif (cmd in D.keys()):
        return handle_d(D[cmd], args)
    elif (cmd in B.keys()):
        return handle_b(B[cmd], args, labels, l_n, line)
    elif (cmd in CB.keys()):
        return handle_cb(CB[cmd], args, labels, l_n, line)
    elif (cmd in IM.keys()):
        return handle_im(IM[cmd], args, l_n, line)    
    else: raise AssertionError(f"Invalid command \"\033[1;31m{cmd}\033[0m\"")


def assemble(i_file: str, o_file: str):
    global VERBOSE_MODE
    global VERILOG_FORMAT
    fin = open(i_file, 'r')
    raw_lines = fin.readlines()
    parsed_lines = []   # Lines post-parse (code only)
    verbose_lines = []
    format_lines = []
    output_lines = []
    labels = {}         # Hash map of labels
    line_number = 0

    # FIRST PASS
    # Initial parsing to store label values and remove comments
    for line in raw_lines:
        line = line.strip(' \t\n')   # Strip whitespace
        # Ignore comment and whitespace lines
        if (line.startswith("//") or line == ""): continue
        # Trim comments off of code lines
        if ("//" in line): line = line[:line.find("//")]
        
        line = line.strip(' \t\n')   # Strip whitespace
        if (line == ""): continue
        # Remove and tokenize labels
        if (":" in line):
            lbl = line[:line.find(":")]
            assert " " not in lbl, f"Invalid Label! line {line_number}: \"\033[1;31m{lbl}\033[0m\""
            labels[lbl] = line_number
            line = line.replace(lbl + ':', '')
            verbose_lines.append(f"{lbl}:")
        
        line = line.strip(' \t\n')   # Strip whitespace
        if (line == ""): continue
        verbose_lines.append("%s:\t%s" % (hex(line_number * 4)[2:], line))
        line = line.replace("XZR", "X31")
        line = line.replace("LR", "X30")
        line = line.replace("FP", "X29")
        line = line.replace("SP", "X28")        
        parsed_lines.append(line)
        line_number += 1
    
    # sanity check
    assert len(parsed_lines) == line_number, f"Failure parsing lines"
    
    # SECOND PASS
    # Final parsing to actually assemble the instructions
    line_number = 0
    program_offset = 0x100
    n_lbls = 0
    for i in range(0, len(verbose_lines)):
        if (verbose_lines[i][:-1] in labels.keys()):
            n_lbls += 1
            continue
        line_number = i - n_lbls
        line = parsed_lines[line_number]
        bin = assemble_line(line, line_number, labels)
        ln = line_number * 4
        output_lines.append("%s:\t%s\t\t// %s\n" % (hex(ln)[2:], bin, line))
        format_lines.append("63'h%s:\tData = 32'h%s;\t\t// %s\n" % (hex(program_offset + ln)[2:].rjust(4, '0'), hex(imm_to_dec('0b' + bin))[2:].rjust(8, '0'), line))
        verbose_lines[i] = verbose_lines[i] + f"\t=>\t{bin}"

    # output results if in verbose mode
    if (VERBOSE_MODE): print("\n".join(verbose_lines))
    
    # writing to file
    fout = open(o_file, 'w')
    fout.writelines(format_lines if VERILOG_FORMAT else output_lines)
    fout.close()


def main():
    global VERBOSE_MODE
    global VERILOG_FORMAT
    inputfile = ''
    outputfile = ''

    parser = argparse.ArgumentParser(
        prog='assembler',
        description='Assemble a given armv8 file into machine code.')
    parser.add_argument('filename', metavar='file', action='store', type=str, help='File to assemble')           # Input file
    parser.add_argument('-o', '--output', metavar='output', action='store', type=str, default='assembled.bin', help='File to write output to')     # Output file
    parser.add_argument('-f', '--format', action='store_true', help='Format for VerilogHDL InstructionMemory module')  # Verbose mode
    parser.add_argument('-v', '--verbose', action='store_true', help='Print helpful outputs during assembling')  # Verbose mode

    args = parser.parse_args()
    VERBOSE_MODE = args.verbose
    VERILOG_FORMAT = args.format
    inputfile = args.filename
    outputfile = args.output
    
    assemble(inputfile, outputfile)

    if (VERBOSE_MODE):
        print("Wrote to \"%s\"" % outputfile)

if __name__ == "__main__":
    main()
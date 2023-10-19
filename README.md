# uProcessador
a VHDL microprocessor

INSTRUCTION (14-0)
opcode (14-11)

INSTRUCTION SET + OPCODES
0x0 -> NOP
0x1 -> ADD A, Rn
0x2 -> SUBB A, Rn
0x3 -> MUL
0x4 -> XRL
0x5 -> MOV Rn, #data
0x6 -> MOV Rn, direct
0xF -> AJMP

REGISTERS
x0-x6 -> general use (R0-R6)
x7 -> accumulator (A)
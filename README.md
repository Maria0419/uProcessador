# uProcessador
a VHDL microprocessor

INSTRUCTION (14-0)
opcode (14-11)

ADD -> src (5-3)
MOV Rn, #data -> imm (10-3) | dest (2-0) 
MOV Rn, A -> dest (2-0)
AJMP -> addr (7-0)

INSTRUCTION SET + OPCODES
0x0 -> NOP
0x1 -> ADD A, Rn
0x2 -> SUBB
0x3 -> MUL
0x4 -> XRL
0x5 -> MOV Rn, #data
0x6 -> MOV Rn, A
0xF -> AJMP addr

REGISTERS
x0 -> zero (constant)
x1-x6 -> general use (R1-R6)
x7 -> accumulator (A)
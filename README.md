# uProcessador
a VHDL microprocessor

INSTRUCTION (14-0)
opcode (14-11)

NOP           -> --
ADD A, Rn     -> source (5-3)
SUBB A, Rn    -> source (5-3)
ANL A, #data  -> immediate (10-3)
XRL A, Rn     -> source (5-3)
MOV Rn, #data -> immediate (10-3) | destination (2-0) 
MOV Rn, A     -> destination (2-0)
CLR C         -> --
MOV A, #data  -> immediate (10-3)
MOV A, @Ri    -> memory register (5-3)
MOV @Ri, A    -> memory register (5-3)
JC rel        -> relative address (7-0) (decimal)
AJMP addr     -> address (7-0) (decimal)


INSTRUCTION SET + OPCODES
0x0 | 0000  -> NOP           
0x1 | 0001  -> ADD A, Rn     
0x2 | 0010  -> SUBB A, Rn    
0x3 | 0011  -> ANL A, #data   
0x4 | 0100  -> XRL A, Rn    
0x5 | 0101  -> MOV Rn, #data  
0x6 | 0110  -> MOV Rn, A   
0x7 | 0111  -> CLR C
0x8 | 1000  -> MOV A, #data
0x9 | 1001  -> MOV A, @Ri
0xA | 1010  -> MOV @Ri, A
0xE | 1110  -> JC rel  
0xF | 1111  -> AJMP addr

REGISTERS
x0    -> zero (constant)
x1-x6 -> general use (R1-R6)
x7    -> accumulator (A)
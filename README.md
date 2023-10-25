# uProcessador
a VHDL microprocessor

INSTRUCTION (14-0)
opcode (14-11)

ADD -> source (5-3)
SUBB -> source (5-3)
MOV Rn, #data -> imm (10-3) | destination (2-0) 
MOV Rn, A -> destination (2-0)
AJMP -> address (7-0) (decimal)


INSTRUCTION SET + OPCODES
0x0 | 0000  -> NOP                    
0x1 | 0001  -> ADD A, Rn              
0x2 | 0010  -> SUBB A, Rn             
0x3 | 0011  -> MUL                    
0x4 | 0100  -> XRL                    
0x5 | 0101  -> MOV Rn, #data 0101     
0x6 | 0110  -> MOV Rn, A 0110         
0xF | 1111  -> AJMP addr              

REGISTERS
x0 -> zero (constant)
x1-x6 -> general use (R1-R6)
x7 -> accumulator (A)
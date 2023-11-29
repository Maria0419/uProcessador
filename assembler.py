#abrir arquivo assembly
with open ('erastotenes.s', 'r') as f:
    arquivo = [linha.lower().strip() for linha in f.readlines()]

#remover comentarios
linhas_descomentadas = []
for linha in arquivo:
    linha = linha.split(';', 1)[0].strip()
    if linha:
        linhas_descomentadas.append(linha)

#processar labels
labels = {}
instrucoes = []
for i, linha in enumerate(linhas_descomentadas):
    if not linha.endswith(':'):
        instrucoes.append(linha)
    else:
        labels[linha[:-1]] = len(instrucoes)

def dec_string_to_bin(num):
    if int(num) < 0:
        num = bin((1 << 8) + int(num))[2:]
    else:
        num = format(int(num), '08b')
    return num

#processar instrucoes
instrucoes_bin = []
instrucoes_bin_vhdl = []
for addr, instr in enumerate(instrucoes):
    #separar instrucao e argumentos
    instr_tokens = instr.split(' ', 1)
    nome_instr = instr_tokens[0]
    args_instr = instr_tokens[1] if len(instr_tokens) > 1 else ''
    

    #processar argumentos
    #se instrucao tem 2 argumentos
    if ',' in args_instr:
        args_instr = [arg.strip() for arg in args_instr.split(',')]

    match nome_instr:
        case 'nop':
            opcode = "0000"
            instr_bin = opcode + "_" + "0"*11
            
        case 'add':
            opcode = "0001"
            if not args_instr[0] == 'a':
                raise Exception(f'Argumento {args_instr[0]} inválido para instrução {nome_instr}')
            
            match args_instr[1]:
                case 'r0':
                    reg = "000"
                case 'r1':
                    reg = "001"
                case 'r2':
                    reg = "010"
                case 'r3':
                    reg = "011"
                case 'r4':
                    reg = "100"
                case 'r5':
                    reg = "101"
                case 'r6':
                    reg = "110"
                case _: 
                    raise Exception(f'Argumento {args_instr[1]} inválido para instrução {nome_instr}')
                
            instr_bin = opcode + "_" + "0"*5 + "_" + reg + "_" + "0"*3
            
        case 'subb':
            opcode = "0010"
            if not args_instr[0] == 'a':
                raise Exception(f'Argumento {args_instr[0]} inválido para instrução {nome_instr}')
            
            match args_instr[1]:
                case 'r0':
                    reg = "000"
                case 'r1':
                    reg = "001"
                case 'r2':
                    reg = "010"
                case 'r3':
                    reg = "011"
                case 'r4':
                    reg = "100"
                case 'r5':
                    reg = "101"
                case 'r6':
                    reg = "110"
                case _: 
                    raise Exception(f'Argumento {args_instr[1]} inválido para instrução {nome_instr}')
                
            instr_bin = opcode + "_" + "0"*5 + "_" + reg + "_" + "0"*3
    
        case 'anl':
            opcode = "0011"
            if not args_instr[0] == 'a':
                raise Exception(f'Argumento {args_instr[0]} inválido para instrução {nome_instr}')
            
            if not args_instr[1].startswith('#'):
                raise Exception(f'Argumento {args_instr[1]} inválido para instrução {nome_instr}')
            
            imm = dec_string_to_bin(args_instr[1][1:])
            instr_bin = opcode + "_" + imm + "_" + "0"*3

        case 'xrl':
            opcode = "0100"
            if not args_instr[0] == 'a':
                raise Exception(f'Argumento {args_instr[0]} inválido para instrução {nome_instr}')
            
            match args_instr[1]:
                case 'r0':
                    reg = "000"
                case 'r1':
                    reg = "001"
                case 'r2':
                    reg = "010"
                case 'r3':
                    reg = "011"
                case 'r4':
                    reg = "100"
                case 'r5':
                    reg = "101"
                case 'r6':
                    reg = "110"
                case _: 
                    raise Exception(f'Argumento {args_instr[1]} inválido para instrução {nome_instr}')
                
            instr_bin = opcode + "_" + "0"*5 + "_" + reg + "_" + "0"*3

        case 'mov':

            # MOV Rn, #data
            if (args_instr[0].startswith('r') and args_instr[1].startswith('#')):
                opcode = "0101"
                match args_instr[0]:
                    case 'r0':
                        reg = "000"
                    case 'r1':
                        reg = "001"
                    case 'r2':
                        reg = "010"
                    case 'r3':
                        reg = "011"
                    case 'r4':
                        reg = "100"
                    case 'r5':
                        reg = "101"
                    case 'r6':
                        reg = "110"
                    case _: 
                        raise Exception(f'Argumento {args_instr[0]} inválido para instrução {nome_instr}')
                
                imm = dec_string_to_bin(args_instr[1][1:])
                instr_bin = opcode + "_" + imm + "_" + reg
            
            # MOV Rn, A
            elif (args_instr[0].startswith('r') and args_instr[1] == 'a'):
                opcode = "0110"
                match args_instr[0]:
                    case 'r0':
                        reg = "000"
                    case 'r1':
                        reg = "001"
                    case 'r2':
                        reg = "010"
                    case 'r3':
                        reg = "011"
                    case 'r4':
                        reg = "100"
                    case 'r5':
                        reg = "101"
                    case 'r6':
                        reg = "110"
                    case _: 
                        raise Exception(f'Argumento {args_instr[0]} inválido para instrução {nome_instr}')
                
                instr_bin = opcode + "_" + "0"*5 + "_" + "0"*3 + "_" + reg

            # MOV A, #data
            elif (args_instr[0] == 'a' and args_instr[1].startswith('#')):
                opcode = "1000"
                imm = dec_string_to_bin(args_instr[1][1:])
                instr_bin = opcode + "_" + imm + "_" + "0"*3
            
            # MOV A, @Ri
            elif (args_instr[0] == 'a' and args_instr[1].startswith('@')):
                opcode = "1001"
                match args_instr[1]:
                    case '@r0':
                        reg = "000"
                    case '@r1':
                        reg = "001"
                    case '@r2':
                        reg = "010"
                    case '@r3':
                        reg = "011"
                    case '@r4':
                        reg = "100"
                    case '@r5':
                        reg = "101"
                    case '@r6':
                        reg = "110"
                    case _: 
                        raise Exception(f'Argumento {args_instr[1]} inválido para instrução {nome_instr}')
                
                instr_bin = opcode + "_" + "0"*5 + "_" + reg + "_" + "0"*3

            # MOV @Ri, A
            elif (args_instr[0].startswith('@') and args_instr[1] == 'a'):
                opcode = "1010"
                match args_instr[0]:
                    case '@r0':
                        reg = "000"
                    case '@r1':
                        reg = "001"
                    case '@r2':
                        reg = "010"
                    case '@r3':
                        reg = "011"
                    case '@r4':
                        reg = "100"
                    case '@r5':
                        reg = "101"
                    case '@r6':
                        reg = "110"
                    case _: 
                        raise Exception(f'Argumento {args_instr[0]} inválido para instrução {nome_instr}')
                
                instr_bin = opcode + "_" + "0"*5 + "_" + reg + "_" + "0"*3
            else:
                raise Exception(f'Argumentos {args_instr} inválidos para instrução {nome_instr}')

        case 'clr':
            if not args_instr == 'c':
                raise Exception(f'Argumento {args_instr} inválido para instrução {nome_instr}')
            
            opcode = "0111"
            instr_bin = opcode + "_" + "0"*11

        case 'jc':
            opcode = "1110"
            
            rel = labels[args_instr] - (addr + 1)
            rel = dec_string_to_bin(rel)

            instr_bin = opcode + "_" + "0"*3 + "_" + rel

        case 'ajmp':
            opcode = "1111"

            dest_addr = dec_string_to_bin(labels[args_instr])

            instr_bin = opcode + "_" + "0"*3 + "_" + dest_addr
            
        case _:
            raise Exception(f'Instrução {nome_instr} não reconhecida')
        
    instrucoes_bin.append(instr_bin)
    instrucoes_bin_vhdl.append(str(addr) + " => " + 'B"' + instr_bin + '"' + "," + "\t-- " + instr)

#salvar arquivo com instrucoes em binario no vhdl
with open('instrucoes_bin_vhdl.txt', 'w') as f:
    f.write('\n'.join(instrucoes_bin_vhdl))
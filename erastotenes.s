MOV r1, #33     ; r1 = cte #33
MOV r2, #1      ; r2 = ind
MOV r3, #1      ; r3 = cte #1
MOV r5, #17     ; r5 = cte #17

; inicializa a ram com ram[i] = i
inicializa_ram:
    MOV a, #0
    ADD a, r2
    MOV @r2, a
    ADD a, r3
    MOV r2, a
    CLR C
    SUBB a, r1
    JC inicializa_ram

MOV r2, #2

; itera pela memoria
loop:
    MOV a, @r2
    MOV r4, a       ; r4 = contRAM
    MOV a, #0
    CLR C
    SUBB a, r4      ; se o numero estiver na lista (aka dif de 0), é primo
    JC primo

; incrementa e continua loop
    MOV a, #0
    ADD a, r2
    ADD a, r3
    MOV r2, a
    CLR C
    SUBB a, r5
    JC loop
    AJMP fim_loop

primo:
    ; encontra o primeiro multiplo do primo
    MOV a, #0
    ADD a, r4
    ADD a, r4
    MOV r6, a       ; r6 = ind2

; remove os multiplos
loop2:
    MOV a, #0
    MOV @r6, a
    ADD a, r6
    ADD a, r4
    MOV r6, a
    CLR C
    SUBB a, r1
    JC loop2

; incrementa e continua loop
    MOV a, #0
    ADD a, r2
    ADD a, r3
    MOV r2, a
    CLR C
    SUBB a, r5
    JC loop

fim_loop:

MOV r2, #2
MOV r5, #0      ; sera usado para mostrar os primos

; ler a ram e armazenar no r6
ler_ram:
    MOV a, @r2
    MOV r4, a       ; r4 = contRAM
    MOV a, #0
    CLR C
    SUBB a, r4
    JC mostrar

    ADD a, r2
    ADD a, r3
    MOV r2, a
    CLR C
    SUBB a, r1
    JC ler_ram
    AJMP fim_leitura

mostrar:
    MOV a, #0
    ADD a, r4
    MOV r5, a
    MOV a, #0
    ADD a, r2
    ADD a, r3
    MOV r2, a
    CLR C
    SUBB a, r1
    JC ler_ram

fim_leitura:
nop
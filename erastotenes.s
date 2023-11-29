mov r1, #33     ; r1 = cte #33
mov r2, #1      ; r2 = indice
mov r3, #1      ; r3 = cte #1
mov r5, #17     ; r5 = cte #17

; inicializa a ram com RAM[i] = i (de 1 a 32)
inicializa_ram:
    ; RAM[indice] = indice
    mov a, #0
    add a, r2
    mov @r2, a
    ; indice++
    add a, r3
    mov r2, a
    ; se indice < 33, continua loop
    clr C
    subb a, r1
    jc inicializa_ram

; reinicializa indice
mov r2, #2

; itera pela memoria
loop:
    ; contRAM = RAM[indice]
    mov a, @r2
    mov r4, a
    mov a, #0
    ; se contRAM /= 0, esta na lista de primos
    clr C
    subb a, r4
    jc primo
    ; se contRAM = 0, foi retirado da lista de primos

    ; indice++
    mov a, #0
    add a, r2
    add a, r3
    mov r2, a
    ; se indice < 17, continua loop
    clr C
    subb a, r5
    jc loop
    ; se indice >= 17, termina loop
    ajmp fim_loop

primo:
    ; encontra o primeiro multiplo do primo
    ; indice2 = contRAM + contRAM
    mov a, #0
    add a, r4
    add a, r4
    mov r6, a

loop2:
    ; RAM[indice2] = 0
    mov a, #0
    mov @r6, a
    ; indice2 += contRAM (proximo multiplo)
    add a, r6
    add a, r4
    mov r6, a
    ; se indice2 < 33, continua loop
    clr C
    subb a, r1
    jc loop2

    ; indice++
    mov a, #0
    add a, r2
    add a, r3
    mov r2, a
    ; se indice < 17, continua loop
    clr C
    subb a, r5
    jc loop

fim_loop:

; reinicializa indice
mov r2, #2
mov r5, #0

; itera pela memoria para leitura
ler_ram:
    ; contRAM = RAM[indice]
    mov a, @r2
    mov r4, a
    mov a, #0
    ; se contRAM /= 0, esta na lista de primos
    clr C
    subb a, r4
    jc mostrar
    ; se contRAM = 0, foi retirado da lista de primos

    ; indice++
    add a, r2
    add a, r3
    mov r2, a
    ; se indice < 33, continua loop
    clr C
    subb a, r1
    jc ler_ram
    ; se indice >= 33, termina loop
    ajmp fim_leitura

mostrar:
    ; r5 = contRAM (primo)
    mov a, #0
    add a, r4
    mov r5, a
    ; indice++
    mov a, #0
    add a, r2
    add a, r3
    mov r2, a
    ; se indice < 33, continua loop
    clr C
    subb a, r1
    jc ler_ram

fim_leitura:
nop
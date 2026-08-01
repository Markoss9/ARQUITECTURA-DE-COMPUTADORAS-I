; ==============================================================================
; Ejercicio 1: Serie de Fibonacci en Memoria
; Descripción: Genera los términos de Fibonacci (< 256) desde la dir 0x40
;              y guarda la cantidad total de términos en la posición posterior.
; ==============================================================================

    MOV C, 0x40       ; C actúa como puntero de memoria, inicia en 0x40
    MOV A, 1          ; Primer término de Fibonacci (F0 = 1)
    MOV B, 1          ; Segundo término de Fibonacci (F1 = 1)

    ; 1. Escribir los dos primeros términos requeridos
    MOV [C], A        ; Guardar 1 en 0x40
    INC C             ; Apuntar a 0x41
    MOV [C], B        ; Guardar 1 en 0x41
    INC C             ; Apuntar a 0x42 para el siguiente término

    MOV D, 2          ; Contador de términos generados (comienza en 2)

LOOP_FIB:
    ; 2. Calcular el siguiente término: Proximo = A + B
    MOV A, [C-2]      ; Leer término n-2
    ADD A, [C-1]      ; Sumar término n-1

    JC FIN            ; Si la suma genera Acarreo (Carry >= 256), terminamos

    ; 3. Almacenar el término válido
    MOV [C], A        ; Guardar el nuevo término en memoria
    INC D             ; Incrementar contador de términos
    INC C             ; Avanzar a la siguiente posición de memoria
    JMP LOOP_FIB      ; Repetir proceso

FIN:
    ; 4. Guardar la cantidad total de términos al final
    MOV [C], D        ; Escribir el total de términos en la posición posterior
    HLT               ; Detener la ejecución del programa

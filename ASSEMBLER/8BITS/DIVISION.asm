; ==============================================================================
; Ejercicio 2: División por Restas Sucesivas
; Descripción: Realiza la división de [0x60] / [0x61]. 
;              Guarda Cociente en 0x62 y Resto en 0x63.
; ==============================================================================

    ; --- Configuración de datos de prueba ---
    MOV [0x60], 37    ; Dividendo (Ejemplo: 37)
    MOV [0x61], 5     ; Divisor   (Ejemplo: 5)
    ; ---------------------------------------

    MOV A, [0x60]     ; A = Dividendo (Irá disminuyendo con las restas)
    MOV B, [0x61]     ; B = Divisor
    MOV C, 0          ; C = Contador del Cociente (Inicia en 0)

    ; Manejo de división por cero
    CMP B, 0
    JZ FIN_DIV        ; Si el divisor es 0, finalizar inmediatamente

LOOP_RESTAS:
    CMP A, B          ; Comparar Dividendo (A) con Divisor (B)
    JB FIN_DIV        ; Si A < B, ya no se puede restar más (Jump if Below)

    SUB A, B          ; Restar el divisor al dividendo
    INC C             ; Incrementar el cociente
    JMP LOOP_RESTAS   ; Repetir ciclo

FIN_DIV:
    ; Guardar resultados en memoria
    MOV [0x62], C     ; Guardar Cociente en 0x62
    MOV [0x63], A     ; Guardar Resto en 0x63 (lo que quedó en A)
    HLT               ; Detener el programa

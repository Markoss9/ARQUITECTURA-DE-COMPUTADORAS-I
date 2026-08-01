; ==============================================================================
; Ejercicio 3: Comparación de Arreglos Mediante Subrutina
; Descripción: Compara datos de 0x80..0x85 con 0x90..0x95.
;              Guarda el mayor en 0xA0..0xA5 (o 0xFF si son iguales).
; ==============================================================================

; --- Carga de datos aleatorios de prueba ---
    MOV [0x80], 12
    MOV [0x81], 45
    MOV [0x82], 88
    MOV [0x83], 30
    MOV [0x84], 100
    MOV [0x85], 5

    MOV [0x90], 25
    MOV [0x91], 45
    MOV [0x92], 12
    MOV [0x93], 30
    MOV [0x94], 200
    MOV [0x95], 1
; -------------------------------------------

    MOV A, 0          ; Desplazamiento/Índice (0 a 5)

MAIN_LOOP:
    CMP A, 6          ; ¿Procesamos los 6 elementos?
    JAE FIN_PROGRAMA  ; Si A >= 6, terminar

    CALL SUBRUTINA_CMP ; Llamar a la subrutina de comparación
    INC A              ; Incrementar índice para la siguiente pareja
    JMP MAIN_LOOP

FIN_PROGRAMA:
    HLT

; ==============================================================================
; SUBRUTINA: SUBRUTINA_CMP
; Propósito: Compara [0x80 + A] con [0x90 + A] y guarda resultado en [0xA0 + A]
; Entrada:   Registro A (Índice del elemento)
; ==============================================================================
SUBRUTINA_CMP:
    ; Calcular direcciones dinámicas
    MOV B, 0x80
    ADD B, A          ; B = Dirección en Bloque 1 (0x80 + A)
    
    MOV C, 0x90
    ADD C, A          ; C = Dirección en Bloque 2 (0x90 + A)
    
    MOV D, 0xA0
    ADD D, A          ; D = Dirección de Destino (0xA0 + A)

    ; Leer valores a comparar
    PUSH A            ; Salvar índice A en la pila
    MOV A, [B]        ; A = Valor del primer bloque
    MOV B, [C]        ; B = Valor del segundo bloque

    CMP A, B
    JZ SON_IGUALES    ; Si A == B, saltar
    JA A_ES_MAYOR     ; Si A > B, saltar

B_ES_MAYOR:
    MOV [D], B        ; Guardar B (mayor) en destino
    JMP FIN_SUBRUTINA

A_ES_MAYOR:
    MOV [D], A        ; Guardar A (mayor) en destino
    JMP FIN_SUBRUTINA

SON_IGUALES:
    MOV [D], 0xFF     ; Guardar 0xFF en destino por igualdad

FIN_SUBRUTINA:
    POP A             ; Restaurar el valor original del índice A
    RET               ; Retornar de la subrutina

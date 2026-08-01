; ==============================================================================
; Ejercicio 4: Suma de 16 Bits en Procesador de 8 Bits
; Operando 1: High=0x51, Low=0x52
; Operando 2: High=0x61, Low=0x62
; Resultado : Carry=0x70, High=0x71, Low=0x72
; ==============================================================================

    ; --- Carga de operandos de prueba ---
    ; Operando 1: 0x12FF  (High = 0x12, Low = 0xFF)
    MOV [0x51], 0x12
    MOV [0x52], 0xFF

    ; Operando 2: 0x0001  (High = 0x00, Low = 0x01)
    ; Suma esperada: 0x1300 (Carry = 0x00, High = 0x13, Low = 0x00)
    MOV [0x61], 0x00
    MOV [0x62], 0x01
    ; ------------------------------------

    ; 1. Suma de los 8 bits de menor peso (Low)
    MOV A, [0x52]     ; Cargar Low del Op 1
    ADD A, [0x62]     ; Sumar Low del Op 2
    MOV [0x72], A     ; Guardar resultado del byte bajo en 0x72

    ; 2. Suma de los 8 bits de mayor peso (High) + Propagación de Acarreo
    MOV A, [0x51]     ; Cargar High del Op 1
    ADD A, [0x61]     ; Sumar High del Op 2

    JNC SIN_CARRY_LOW ; Si no hubo acarreo en los bytes bajos, saltar
    INC A             ; Si hubo acarreo (Carry), sumar 1 al byte alto

SIN_CARRY_LOW:
    ; Comprobar si al sumar la parte alta (o el acarreo) ocurrió un overflow final
    JC CARRY_FINAL    ; Si hay acarreo en los bits altos, ir a manejarlo
    MOV [0x70], 0     ; Si no hay acarreo final, el Carry general es 0
    JMP FIN_SUMA

CARRY_FINAL:
    MOV [0x70], 1     ; Guardar 1 en la posición del Acarreo final

FIN_SUMA:
    MOV [0x71], A     ; Guardar el byte alto final en 0x71
    HLT               ; Detener la ejecución

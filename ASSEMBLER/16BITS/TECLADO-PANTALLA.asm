; ==============================================================================
; Actividad 1.1: Control de Color con Teclado
; Descripción: Pinta la pantalla (0x0300 a 0x03FF) píxel a píxel.
;              Teclado:
;                - Tecla '1' (ASCII 0x31) -> Color Azul (0x03)
;                - Tecla '2' (ASCII 0x32) -> Color Amarillo (0xFC)
; ==============================================================================

    MOV DI, 0x0300        ; DI = Puntero al primer píxel de la pantalla
    MOV AL, 0x03          ; Color inicial: Azul (0x03 en paleta estándar)

PINTAR_LOOP:
    CMP DI, 0x0400        ; ¿Llegamos al final de la pantalla (0x03FF)?
    JAE FIN_PROGRAMA      ; Si DI >= 0x0400, termina

    ; --- Lectura de Teclado ---
    IN BL, 0              ; Leer puerto de entrada del teclado a BL

    CMP BL, 0x31          ; ¿Se presionó la tecla '1'? (Código ASCII '1' = 0x31)
    JE SET_AZUL

    CMP BL, 0x32          ; ¿Se presionó la tecla '2'? (Código ASCII '2' = 0x32)
    JE SET_AMARILLO

    JMP PINTAR_PIXEL      ; Si no hay cambio de tecla, conservar color actual

SET_AZUL:
    MOV AL, 0x03          ; Cambiar color activo a Azul
    JMP PINTAR_PIXEL

SET_AMARILLO:
    MOV AL, 0xFC          ; Cambiar color activo a Amarillo
    JMP PINTAR_PIXEL

PINTAR_PIXEL:
    MOV [DI], AL          ; Escribir el color actual en la dirección de RAM
    INC DI                ; Avanzar al siguiente píxel
    JMP PINTAR_LOOP       ; Continuar ciclo

FIN_PROGRAMA:
    HLT                   ; Detener la ejecución

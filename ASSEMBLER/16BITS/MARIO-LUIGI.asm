; ==============================================================================
; Actividad 1.2: Conversión de Mario Bross a Luigi
; Descripción: Dibuja a Mario mediante el sprite de la muestra y luego
;              recorre la memoria gráfica reemplazando el Rojo por Verde.
; ==============================================================================

; --- CÓDIGO DEL SAMPLE "DRAW SPRITE" (Dibuja a Mario) ---
; (Asegúrate de pegar el código del Sample previo a este bloque de modificación)

; ------------------------------------------------------------------------------
; TRANSICIÓN A LUIGI (Reemplaza la instrucción HLT del sample)
; ------------------------------------------------------------------------------

    MOV DI, 0x0300        ; Inicio de la memoria de pantalla (VRAM)

RECORRER_PANTALLA:
    CMP DI, 0x0400        ; ¿Recorrimos toda la VRAM (0x0300 a 0x03FF)?
    JAE FIN_LUIGI         ; Si terminamos, detener programa

    MOV AL, [DI]          ; Leer el color del píxel actual
    CMP AL, 0xC4          ; ¿Es de color Rojo (0xC4)?
    JNZ SIGUIENTE_PIXEL   ; Si no es rojo, ignorar y pasar al siguiente

    MOV BYTE [DI], 0x15   ; Si era rojo, cambiar por Verde (0x15)

SIGUIENTE_PIXEL:
    INC DI                ; Avanzar al siguiente píxel
    JMP RECORRER_PANTALLA

FIN_LUIGI:
    HLT                   ; Fin de la transformación

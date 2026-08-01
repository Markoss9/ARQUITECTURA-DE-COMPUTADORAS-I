; ==============================================================================
; Actividad 1.3: Camiseta de River Plate
; Descripción: Genera un fondo Blanco (0xFF) y una franja Roja (0xC4)
;              a -45° centrada con un ancho de 5 píxeles.
; ==============================================================================

    MOV DI, 0x0300        ; Apuntar al inicio de la VRAM
    MOV CX, 0             ; CX = Fila (y) de 0 a 15

BUCLE_FILA:
    CMP CX, 16            ; ¿Procesamos las 16 filas?
    JAE FIN_DIBUJO
    MOV DX, 0             ; DX = Columna (x) de 0 a 15

BUCLE_COLUMNA:
    CMP DX, 16            ; ¿Procesamos las 16 columnas de la fila?
    JAE SIGUIENTE_FILA

    ; --- Calcular diferencia (x - y) para determinar la franja ---
    MOV AL, DL           ; AL = x
    SUB AL, CL           ; AL = x - y (usando aritmética de 8 bits con signo)

    ; Comprobar límites para franja de ancho 5: AL entre -2 (0xFE) y +2 (0x02)
    CMP AL, 2
    JG ES_BLANCO          ; Si (x - y) > 2 -> Fondo Blanco
    CMP AL, -2
    JL ES_BLANCO          ; Si (x - y) < -2 -> Fondo Blanco

ES_ROJO:
    MOV BYTE [DI], 0xC4   ; Píxel perteneciente a la franja -> Color Rojo
    JMP AVANZAR_PIXEL

ES_BLANCO:
    MOV BYTE [DI], 0xFF   ; Píxel de fondo -> Color Blanco

AVANZAR_PIXEL:
    INC DI                ; Siguiente posición en memoria de video
    INC DX                ; Siguiente columna (x++)
    JMP BUCLE_COLUMNA

SIGUIENTE_FILA:
    INC CX                ; Siguiente fila (y++)
    JMP BUCLE_FILA

FIN_DIBUJO:
    HLT

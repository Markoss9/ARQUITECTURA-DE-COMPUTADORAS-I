/* ==============================================================================
 * Actividad 2.1: Introducción a Interrupciones en Arduino
 * Descripción: Secuencia de LEDs (6-13) interrumpible por los pines 2 (INT0)
 *              y 3 (INT1).
 * ============================================================================== */

const byte PIN_INT0 = 2; // Pulsador 1
const byte PIN_INT1 = 3; // Pulsador 2

void setup() {
  // Configurar pines 6 al 13 como salidas
  for (int pin = 6; pin <= 13; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, LOW);
  }

  // Configurar pines de interrupción como entradas con pull-up interno
  pinMode(PIN_INT0, INPUT_PULLUP);
  pinMode(PIN_INT1, INPUT_PULLUP);

  // Adjuntar interrupciones al flanco descendente (FALLING al presionar el botón)
  attachInterrupt(digitalPinToInterrupt(PIN_INT0), isr_pin2, FALLING);
  attachInterrupt(digitalPinToInterrupt(PIN_INT1), isr_pin3, FALLING);
}

void loop() {
  // Secuencia principal: Encendido consecutivo de LEDs del 6 al 13
  for (int pin = 6; pin <= 13; pin++) {
    digitalWrite(pin, HIGH);
    delay(800); // 0.8 segundos
    digitalWrite(pin, LOW);
  }
}

// ------------------------------------------------------------------------------
// Helper: Pausa larga en microsegundos (evita el límite de 16383 µs)
// ------------------------------------------------------------------------------
void delayMicrosecondsLong(unsigned long ms) {
  while (ms > 0) {
    if (ms >= 10) {
      delayMicroseconds(10000); // Bloques de 10.000 µs (10 ms)
      ms -= 10;
    } else {
      delayMicroseconds(ms * 1000);
      ms = 0;
    }
  }
}

// ------------------------------------------------------------------------------
// Helper: Apagar todos los LEDs
// ------------------------------------------------------------------------------
void apagarTodosLeds() {
  for (int p = 6; p <= 13; p++) {
    digitalWrite(p, LOW);
  }
}

// ==============================================================================
// ISR Pin 2: Parpadeo de LED 7 durante 4s + 1s encendido
// ==============================================================================
void isr_pin2() {
  apagarTodosLeds();

  // Parpadeo durante 4 segundos (40 ciclos de 100ms: 50ms ON / 50ms OFF)
  for (int i = 0; i < 40; i++) {
    digitalWrite(7, HIGH);
    delayMicrosecondsLong(50);
    digitalWrite(7, LOW);
    delayMicrosecondsLong(50);
  }

  // Permanece encendido durante 1 segundo (1000 ms)
  digitalWrite(7, HIGH);
  delayMicrosecondsLong(1000);
  digitalWrite(7, LOW);
}

// ==============================================================================
// ISR Pin 3: Parpadeo de LED 12 durante 4s + 1s encendido
// ==============================================================================
void isr_pin3() {
  apagarTodosLeds();

  // Parpadeo durante 4 segundos (40 ciclos de 100ms: 50ms ON / 50ms OFF)
  for (int i = 0; i < 40; i++) {
    digitalWrite(12, HIGH);
    delayMicrosecondsLong(50);
    digitalWrite(12, LOW);
    delayMicrosecondsLong(50);
  }

  // Permanece encendido durante 1 segundo (1000 ms)
  digitalWrite(12, HIGH);
  delayMicrosecondsLong(1000);
  digitalWrite(12, LOW);
}

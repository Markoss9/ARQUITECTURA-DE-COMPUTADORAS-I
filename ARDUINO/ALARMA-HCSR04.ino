/* ==============================================================================
 * Actividad 2.2: Alarma de Distancia con Sensor HC-SR04
 * Descripción:
 *   - Pin 2 (INT0): Activa la alarma.
 *   - Pin 3 (INT1): Desactiva la alarma.
 *   - Mide la distancia cada 0.8s.
 *   - Si está Activada y d < 100 cm (1m), activa alerta de intruso.
 * ============================================================================== */

const byte PIN_TRIG = 5;
const byte PIN_ECHO = 4;
const byte PIN_INT_ACTIVAR = 2;
const byte PIN_INT_DESACTIVAR = 3;

// Variable compartida entre ISRs y el loop principal (debe ser volatile)
volatile bool alarmaActivada = false;

void setup() {
  Serial.begin(9600);

  // Configuración de LEDs
  for (int pin = 6; pin <= 13; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, LOW);
  }

  // Configuración de Ultrasonido
  pinMode(PIN_TRIG, OUTPUT);
  pinMode(PIN_ECHO, INPUT);

  // Configuración de Interrupciones
  pinMode(PIN_INT_ACTIVAR, INPUT_PULLUP);
  pinMode(PIN_INT_DESACTIVAR, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(PIN_INT_ACTIVAR), isr_activar, FALLING);
  attachInterrupt(digitalPinToInterrupt(PIN_INT_DESACTIVAR), isr_desactivar, FALLING);

  Serial.println("Sistema Inicializado. Estado: Alarma Desactivada");
}

void loop() {
  // 1. Enviar pulso TRIG de 10 µs al HC-SR04
  digitalWrite(PIN_TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(PIN_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG, LOW);

  // 2. Leer tiempo de retorno en ECHO (Timeout a 30000 µs = ~5 metros)
  unsigned long duracion = pulseIn(PIN_ECHO, HIGH, 30000);

  // 3. Calcular distancia en cm (Velocidad del sonido: 58 µs/cm)
  unsigned long distanciaCm = duracion / 58;

  // 4. Imprimir reporte por Serial
  Serial.print("Distancia: ");
  Serial.print(distanciaCm);
  Serial.print(" cm | Estado: ");
  if (alarmaActivada) {
    Serial.println("Alarma Activada");
  } else {
    Serial.println("Alarma Desactivada");
  }

  // 5. Evaluación de Intruso
  if (alarmaActivada && distanciaCm < 100 && distanciaCm > 0) {
    Serial.println("⚠️ ¡ALERTA DE INTRUSO DETECTADO! ⚠️");
    parpadearLedsIntruso();
  }

  // Intervalo de muestreo: 0.8 segundos
  delay(800);
}

// ------------------------------------------------------------------------------
// Rutinas de Servicio de Interrupción (ISRs Livianas)
// ------------------------------------------------------------------------------
void isr_activar() {
  alarmaActivada = true;
}

void isr_desactivar() {
  alarmaActivada = false;
  // Apagar LEDs si estaban encendidos por la alerta
  for (int p = 6; p <= 13; p++) {
    digitalWrite(p, LOW);
  }
}

// ------------------------------------------------------------------------------
// Alerta visual de intruso
// ------------------------------------------------------------------------------
void parpadearLedsIntruso() {
  for (int i = 0; i < 5; i++) {
    for (int p = 6; p <= 13; p++) digitalWrite(p, HIGH);
    delay(100);
    for (int p = 6; p <= 13; p++) digitalWrite(p, LOW);
    delay(100);
  }
}

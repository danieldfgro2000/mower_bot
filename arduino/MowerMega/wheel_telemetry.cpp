#include "wheel_telemetry.h"
#include <Arduino.h>

const int distEnc = 2;
const int turnEnc = 3;
const float wheelDiameter = 15.0; //cm
const int wheelPPR = 100; // pulses per revolution
const int anglePPR = 60;

volatile long distCount = 0;
volatile long turnCount = 0;
unsigned long lastUpdate = 0;
float wheelSpeed = 0.0;

// Debounce for the turn encoder pulses at ISR level to reduce noise at hard stops
static volatile unsigned long g_turnDebounceUs = 5000; // default 5ms, adjustable
static volatile unsigned long g_lastTurnPulseUs = 0;

void distISR() {
  distCount ++;
}

void turnISR() {
  unsigned long nowUs = micros();
  // simple debounce: accept pulse only if enough time passed
  if ((nowUs - g_lastTurnPulseUs) >= g_turnDebounceUs) {
    turnCount ++;
    g_lastTurnPulseUs = nowUs;
  }
}

void wheelTelemetryInit() {
  pinMode(distEnc, INPUT_PULLUP);
  pinMode(turnEnc, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(distEnc), distISR, RISING);
  attachInterrupt(digitalPinToInterrupt(turnEnc), turnISR, RISING);

  distCount = 0;
  turnCount = 0;
  g_lastTurnPulseUs = micros();
}

void wheelTelemetryUpdate() {
  unsigned long now = millis();
  static long lastDistCount = 0;
  static long lastTurnCount = 0;

  if (now - lastUpdate >= 200) {
    long delta  = distCount - lastDistCount;
    float revs  = (float)delta / wheelPPR;
    wheelSpeed = (revs * (wheelDiameter * PI)) / ((now - lastUpdate) / 1000.0);
    lastDistCount = distCount;
    lastUpdate = now;
  }
}

float wheelGetDistance() {
  float revs = (float)distCount / wheelPPR;
  return revs * (wheelDiameter * PI);
}

float wheelGetSpeed() { 
  return wheelSpeed; 
}

float wheelGetAngle() {
    // this should always be between 0 and 360
    float revs = (float)turnCount / anglePPR;
    float angle = revs * 360.0f;
    angle = fmod(angle, 360.0f);
    return angle;
}

void wheelReset() {
  distCount = 0;
  turnCount = 0;
}

// New getter for raw turn encoder count
long wheelGetTurnCount() {
  noInterrupts();
  long val = turnCount;
  interrupts();
  return val;
}

int wheelGetAnglePPR() { return anglePPR; }

void wheelSetTurnDebounceMicros(unsigned long us) {
  noInterrupts();
  g_turnDebounceUs = us;
  interrupts();
}

unsigned long wheelGetTurnDebounceMicros() {
  noInterrupts();
  unsigned long v = g_turnDebounceUs;
  interrupts();
  return v;
}

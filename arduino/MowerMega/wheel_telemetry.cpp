#include "wheel_telemetry.h"
#include <Arduino.h>

const int wheelEncA = 22;
const int wheelEncB = 23;
const float wheelDiameter = 0.15; //cm
const int wheelPPR = 600; // pulses per revolution

volatile long wheelCount = 0;
unsigned long lastUpdate = 0;
float wheelSpeed = 0.0;

void wheelISR() {
  int b = digitalRead(wheelEncB);
  wheelCount += (b == HIGH) ? 1 : -1;
}

void wheelTelemetryInit() {
  pinMode(wheelEncA, INPUT_PULLUP);
  pinMode(wheelEncB, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(wheelEncA), wheelISR, RISING);
  wheelCount = 0;
}

void wheelTelemetryUpdate() {
  unsigned long now = millis();
  static long lastCount = 0;

  if (now - lastUpdate >= 200) {
    long delta  = wheelCount - lastCount;
    float revs  = (float)delta / wheelPPR;
    wheelSpeed = (revs * (wheelDiameter * PI)) / ((now - lastUpdate) / 1000.0);
    lastCount = wheelCount;
    lastUpdate = now;
  }
}

float wheelGetDistance() {
  float revs = (float)wheelCount / wheelPPR;
  return revs * (wheelDiameter * PI);
}

float wheelGetSpeed() { 
  return wheelSpeed; 
}

void wheelReset() {
  wheelCount = 0;
}

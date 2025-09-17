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

void distISR() {
  distCount ++;
}

void turnISR() {
  turnCount ++;
}

void wheelTelemetryInit() {
  pinMode(distEnc, INPUT_PULLUP);
  pinMode(turnEnc, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(distEnc), distISR, RISING);
  attachInterrupt(digitalPinToInterrupt(turnEnc), turnISR, RISING);

  distCount = 0;
  turnCount = 0;
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

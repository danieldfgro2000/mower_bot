#include "actuators.h"
#include <Arduino.h>

const int startActuatorPin = 11;
const int driveActuatorPin = 12;

void actuatorsInit() {
    Serial.println("[ACTUATORS] Init\n");
  pinMode(startActuatorPin, OUTPUT);
  pinMode(driveActuatorPin, OUTPUT);
}

void actuatorStart(bool state) {
    Serial.print("[ACTUATOR] Start");
    Serial.println(state ? " ON" : " OFF");
  digitalWrite(startActuatorPin, state ? HIGH : LOW);
}

void actuatorDrive(bool state) {
    Serial.print("[ACTUATOR] Drive");
    Serial.println(state ? " ON" : " OFF");
  digitalWrite(driveActuatorPin, state ? HIGH : LOW);
}

bool actuatorIsDriving() {
  return digitalRead(driveActuatorPin) == HIGH;
}

bool actuatorIsStarted() {
  return digitalRead(startActuatorPin) == HIGH;
}

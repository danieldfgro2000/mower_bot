#include "actuators.h"
#include <Arduino.h>

const int startActuatorPin = 30;
const int driveActuatorPin = 31;

void actuatorsInit() {
    Serial.println("[ACTUATORS] Init\n");
  pinMode(startActuatorPin, OUTPUT);
  pinMode(driveActuatorPin, OUTPUT);
}

void actuatorStart(bool state) {
    Serial.println("[ACTUATOR] Start");
  digitalWrite(startActuatorPin, state ? HIGH : LOW);
}

void actuatorDrive(bool state) {
    Serial.println("[ACTUATOR] Drive");
  digitalWrite(driveActuatorPin, state ? HIGH : LOW);
}

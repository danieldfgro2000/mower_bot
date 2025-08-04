#include "actuators.h"
#include <Arduino.h>

const int startActuatorPin = 30;
const int driveActuatorPin = 31;

void actuatorsInit() {
  pinMode(startActuatorPin, OUTPUT);
  pinMode(driveActuatorPin, OUTPUT);
}

void actuatorStart(bool state) {
  digitalWrite(startActuatorPin, state ? HIGH : LOW);
}

void actuatorDrive(bool state) {
  digitalWrite(driveActuatorPin, state ? HIGH : LOW);
}

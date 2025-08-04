#include "steering.h"
#include "wheel_telemetry.h"
#include "actuators.h"
#include "messaging.h"

void setup() {
 Serial.begin(115200);
 Serial1.begin(115200);

  steeringInit();
  wheelTelemetryInit();
  actuatorsInit();
  messagingInit();

  Serial.println("System starting...");
}

void loop() {
  if(!steeringIsHomed()) {
    steeringHome();
    return;
  }

  messagingHandleInput();
  steeringUpdate();
  wheelTelemetryUpdate();
  messagingSendTelemetry();
}

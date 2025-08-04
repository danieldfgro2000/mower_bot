#include "steering.h"
#include "wheel_telemetry.h"
#include "actuators.h"
#include "messaging.h"
#include "path_manager_global.h"

PathManager pathManager(10);

void setup() {
 Serial.begin(115200);
 Serial1.begin(115200);

  steeringInit();
  wheelTelemetryInit();
  actuatorsInit();
  messagingInit();
  pathManager.begin();

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

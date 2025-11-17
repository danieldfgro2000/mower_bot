#include "steering.h"
#include "wheel_telemetry.h"
#include "actuators.h"
#include "messaging.h"
#include "security_watchdog.h"

void setup() {
    Serial.begin(115200);
    Serial1.begin(115200);
    Serial1.setTimeout(500);

    Serial.println();
    Serial.println();
    Serial.println("############### SYSTEM STARTING ###############");

    securityWatchdogInit();
    wheelTelemetryInit();
    actuatorsInit();

    steeringInit();
}

void loop() {
    if (!steeringIsHomed()) {
        steeringHome();
        return;
    }

    securityWatchdogUpdate();
    messagingHandleInput();
    steeringUpdate();
    wheelTelemetryUpdate();
    messagingSendTelemetry();
}

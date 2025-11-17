#pragma once
#include <Arduino.h>

void wheelTelemetryInit();
void wheelTelemetryUpdate();
float wheelGetAngle();
float wheelGetDistance();
float wheelGetSpeed();
void wheelReset();

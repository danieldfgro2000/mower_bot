#pragma once
#include <Arduino.h>

void wheelTelemetryInit();
void wheelTelemetryUpdate();
float wheelGetAngle();
float wheelGetDistance();
float wheelGetSpeed();
void wheelReset();
long wheelGetTurnCount();
// New accessors/configuration for steering homing robustness
// Returns the pulses-per-revolution for the steering angle encoder
int wheelGetAnglePPR();
// Configure a debounce interval (in microseconds) for the steering turn encoder ISR
void wheelSetTurnDebounceMicros(unsigned long us);
// Read back the currently configured debounce interval (microseconds)
unsigned long wheelGetTurnDebounceMicros();

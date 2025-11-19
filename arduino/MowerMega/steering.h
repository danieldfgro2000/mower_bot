#pragma once
#include <AccelStepper.h>

void steeringInit();
void steeringHome();
void steeringUpdate();
void steeringSetAngle(float angle);
float steeringGetCommandedAngle();
bool steeringIsHomed();
void steeringSetHomingNoPulseMs(unsigned long ms);

// Angle helpers
float steeringGetPhysicalAngle();

// Limit queries (after homing)
long steeringGetLimitLeftSteps();
long steeringGetLimitRightSteps();
float steeringGetLimitLeftDeg();
float steeringGetLimitRightDeg();

// Simple manual zeroing: define a wheel angle (deg) to become new logical 0 after homing.
void steeringSetZeroAngleDeg(float angleDeg);

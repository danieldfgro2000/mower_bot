#pragma once
#include <AccelStepper.h>

void steeringInit();
void steeringHome();
void steeringUpdate();
void steeringSetAngle(float angle);
float steeringGetCommandedAngle();
bool steeringIsHomed();
void steeringSetHomingNoPulseMs(unsigned long ms);

#pragma once

void actuatorsInit();
void actuatorStart(bool state);
void actuatorDrive(bool state);
bool actuatorIsDriving();
bool actuatorIsStarted();

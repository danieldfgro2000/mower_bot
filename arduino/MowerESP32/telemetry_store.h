#pragma once
#include <Arduino.h>

void telemetryStoreInit();
void telemetryUpdateFromMega(String json);
String telemetryGet();

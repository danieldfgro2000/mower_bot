#pragma once
#include <Arduino.h>


void securityWatchdogInit();
void securityWatchdogOnEspKeepAlive(uint32_t t_ms);
void securityWatchdogUpdate();

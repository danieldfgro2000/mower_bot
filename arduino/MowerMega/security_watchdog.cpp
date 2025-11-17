#include "security_watchdog.h"
#include "actuators.h"

static uint32_t lastHbMs = 0;
static uint32_t misses = 0;

static const uint32_t CHECK_INTERVAL_MS = 1000;
static const uint32_t TIMEOUT_MS = 3000;
static const uint32_t MAX_MISSES = 3;

static uint32_t lastCheckMs = 0;

void securityWatchdogInit() {
    lastHbMs = 0;
    misses = 0;
    lastCheckMs = millis();
}

void securityWatchdogOnEspKeepAlive(uint32_t /*t_ms*/) {
    lastHbMs = millis();
    misses = 0;
}

void securityWatchdogUpdate() {
    const uint32_t now = millis();
    if (now - lastCheckMs < CHECK_INTERVAL_MS) return;
    lastCheckMs = now;

    if (lastHbMs == 0 || now - lastHbMs > TIMEOUT_MS) {
        if (misses < 255) misses++;
        if (misses >= MAX_MISSES) {
            Serial.println("[WATCHDOG] No heartbeat from ESP32 - stopping actuators!");
            actuatorStart(false);
            actuatorDrive(false);
        }
    }
}
#include "telemetry_store.h"

static String lastTelemetry = "{}";

void telemetryStoreInit() {
  lastTelemetry = "{}";
}

void telemetryUpdateFromMega(String json) {
  lastTelemetry = json;
}


String telemetryGet() {
  return lastTelemetry;
}

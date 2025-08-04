#include "telemetry_store.h"
#include "websocket_server.h"


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

void sendTelemetry() {
  if(!connectionManager.sendMessage(lastTelemetry)) {
    Serial.println("Telemetry not sent: no active WebSocket client");
  }
}

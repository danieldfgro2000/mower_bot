#include "serial_link.h"
#include "telemetry_store.h"
#include "websocket_server.h"
#include <ArduinoJson.h>

void serialLinkInit() {
  Serial2.begin(115200, SERIAL_8N1, 16, 17);
}

void serialLinkLoop() {
  if(!Serial2.available()) return;

  String telemetry = Serial2.readStringUntil('\n');
  telemetry.trim();

  StaticJsonDocument<256> doc;
  DeserializationError err = deserializeJson(doc, telemetry);

  if(err) {
    Serial.println("[ERR] Telemetry JSON parse failed");
    return;
  }
  telemetryUpdateFromMega(telemetry);
  connectionManager.sendMessage(telemetry);
  Serial.println("[TELEMETRY]" + telemetry);
}
